import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/models/response/notify_me/notify_subscription_model.dart';
import 'package:almasry_2/core/models/response/product_details/product_details_args_model.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/db_services.dart';
import 'package:almasry_2/core/services/navigation_service.dart';

class PushNotificationService {
  /// Services

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  NavigationService get _nav => sl<NavigationService>();

  /// Constants

  // Must match `default_notification_channel_id` in AndroidManifest.xml.
  static const String channelId = 'almasry_product_availability';

  static const String _channelName = 'Product availability';
  static const String _channelDescription =
      'Alerts you when a product you asked about is back in stock.';

  static const int _availabilityAlertId = 4001;

  static const int _remoteMessageId = 4002;

  /// Variables

  String? _fcmToken;

  ProductDetailsArgs? _pendingDeepLink;

  bool _isInitialized = false;

  String? get fcmToken => _fcmToken;

  bool get hasPendingDeepLink => _pendingDeepLink != null;

  /// Init

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    tz_data.initializeTimeZones();

    await _initLocalNotifications();
    await _createChannel();
    await requestPermission();
    await _refreshToken();

    _listenForMessages();
    await _captureColdStartTap();
  }

  Future<void> _initLocalNotifications() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        _handleTap(_decodePayload(response.payload));
      },
    );
  }

  Future<void> _createChannel() async {
    await _androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );
  }

  /// Permissions

  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();

    await _androidPlugin?.requestNotificationsPermission();

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin {
    return _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
  }

  /// Token

  Future<String?> getToken() async {
    if (_fcmToken != null) return _fcmToken;
    await _refreshToken();
    return _fcmToken;
  }

  Future<void> _refreshToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      debugPrint('FCM token: $_fcmToken');
    } catch (e) {
      debugPrint('FCM token unavailable: $e');
    }
  }

  /// Subscriptions

  Future<bool> subscribeToAvailability({
    required String sku,
    required String productName,
    required String imagePath,
    required String notificationTitle,
    required String notificationBody,
    Duration delay = const Duration(minutes: 1),
  }) async {
    final token = await getToken();

    if (token == null || token.isEmpty) return false;

    await DbServices.instance.addNotifySubscription(
      NotifySubscriptionModel(
        sku: sku,
        productName: productName,
        imagePath: imagePath,
        fcmToken: token,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    await scheduleAvailabilityAlert(
      product: ProductDetailsArgs(
        sku: sku,
        title: productName,
        imagePath: imagePath,
      ),
      title: notificationTitle,
      body: notificationBody,
      delay: delay,
    );

    return true;
  }

  Future<bool> isSubscribed(String sku) {
    return DbServices.instance.isNotifySubscribed(sku);
  }

  /// Scheduling

  Future<void> scheduleAvailabilityAlert({
    required ProductDetailsArgs product,
    required String title,
    required String body,
    Duration delay = const Duration(minutes: 1),
  }) async {
    final scheduledAt = tz.TZDateTime.from(DateTime.now().add(delay), tz.UTC);

    Future<void> schedule(AndroidScheduleMode mode) {
      return _localNotifications.zonedSchedule(
        id: _availabilityAlertId,
        title: title,
        body: body,
        scheduledDate: scheduledAt,
        notificationDetails: _notificationDetails(),
        androidScheduleMode: mode,
        payload: _encodePayload(product),
      );
    }

    try {
      await schedule(await _resolveScheduleMode());
    } on PlatformException catch (e) {
      if (e.code != 'exact_alarms_not_permitted') rethrow;

      await schedule(AndroidScheduleMode.inexactAllowWhileIdle);
    }
  }

  Future<AndroidScheduleMode> _resolveScheduleMode() async {
    final canScheduleExact =
        await _androidPlugin?.canScheduleExactNotifications() ?? true;

    return canScheduleExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  Future<void> cancelAvailabilityAlert() {
    return _localNotifications.cancel(id: _availabilityAlertId);
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  /// Incoming messages

  void _listenForMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _showNow(
        title: notification.title,
        body: notification.body,
        payload: _encodePayload(_deepLinkFromData(message.data)),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleTap(_deepLinkFromData(message.data));
    });

    _messaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
    });
  }

  Future<void> _showNow({String? title, String? body, String? payload}) {
    return _localNotifications.show(
      id: _remoteMessageId,
      title: title,
      body: body,
      notificationDetails: _notificationDetails(),
      payload: payload,
    );
  }

  Future<void> _captureColdStartTap() async {
    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _pendingDeepLink = _deepLinkFromData(initialMessage.data);
      return;
    }

    final launchDetails = await _localNotifications
        .getNotificationAppLaunchDetails();

    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _pendingDeepLink = _decodePayload(
        launchDetails?.notificationResponse?.payload,
      );
    }
  }

  /// Deep linking

  void _handleTap(ProductDetailsArgs? product) {
    if (product == null) return;

    _navigateToProduct(product);
  }

  void dispatchPendingDeepLink() {
    final pending = _pendingDeepLink;
    if (pending == null) return;

    _pendingDeepLink = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToProduct(pending);
    });
  }

  void _navigateToProduct(ProductDetailsArgs product) {
    _nav.pushNamed(RouteNames.productDetails, extra: product);
  }

  /// Payload

  String _encodePayload(ProductDetailsArgs? product) {
    if (product == null) return '';

    return jsonEncode({
      'sku': product.sku,
      'title': product.title ?? '',
      'imagePath': product.imagePath ?? '',
    });
  }

  ProductDetailsArgs? _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map) return null;

      return _deepLinkFromData(
        decoded.map((key, value) => MapEntry(key.toString(), value)),
      );
    } catch (_) {
      return null;
    }
  }

  ProductDetailsArgs? _deepLinkFromData(Map<String, dynamic> data) {
    final sku = data['sku']?.toString() ?? '';
    if (sku.isEmpty) return null;

    final title = data['title']?.toString() ?? '';
    final imagePath = data['imagePath']?.toString() ?? '';

    return ProductDetailsArgs(
      sku: sku,
      title: title.isEmpty ? null : title,
      imagePath: imagePath.isEmpty ? null : imagePath,
    );
  }
}
