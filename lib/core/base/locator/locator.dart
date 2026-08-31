import 'package:almasry_2/core/services/address_book_service.dart';
import 'package:almasry_2/core/services/alert_service.dart';
import 'package:almasry_2/core/services/api_logger_interceptor_service.dart';
import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/core/services/app_startup_service.dart';
import 'package:almasry_2/core/services/auth_session_service.dart';
import 'package:almasry_2/core/services/cache_manager_service.dart';
import 'package:almasry_2/core/services/cart_service.dart';
import 'package:almasry_2/core/services/db_services.dart';
import 'package:almasry_2/core/services/favorites_service.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:almasry_2/core/services/navigation_service.dart';
import 'package:almasry_2/core/services/network_logger_service.dart';
import 'package:almasry_2/core/services/push_notification_service.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:almasry_2/core/services/user_profile_service.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<SharedPrefsServices>(() => SharedPrefsServices());

  sl.registerLazySingleton<DbServices>(() => DbServices());

  sl.registerLazySingleton<NetworkLoggerService>(
    () => const NetworkLoggerService(),
  );

  sl.registerLazySingleton<ApiLoggerInterceptorService>(
    () => ApiLoggerInterceptorService(logger: sl<NetworkLoggerService>()),
  );

  sl.registerLazySingleton<ApiService>(() => ApiService());

  sl.registerLazySingleton<GraphQLService>(() => GraphQLService());

  sl.registerLazySingleton<AuthSessionService>(() => AuthSessionService());

  sl.registerLazySingleton<AppStartupService>(() => AppStartupService());

  sl.registerLazySingleton<UserProfileService>(() => UserProfileService());

  sl.registerLazySingleton<FavoritesService>(() => FavoritesService());

  sl.registerLazySingleton<CartService>(() => CartService());

  sl.registerLazySingleton<AddressBookService>(() => AddressBookService());

  sl.registerLazySingleton<NavigationService>(() => NavigationService());

  sl.registerLazySingleton<AlertService>(() => AlertService());

  sl.registerLazySingleton<CacheManagerService>(() => CacheManagerService());

  sl.registerLazySingleton<PushNotificationService>(
    () => PushNotificationService(),
  );
}
