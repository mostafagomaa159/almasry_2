import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/core/services/app_startup_service.dart';
import 'package:almasry_2/core/services/auth_session_service.dart';
import 'package:almasry_2/core/services/favorites_service.dart';
import 'package:almasry_2/core/services/navigation_service.dart';
import 'package:almasry_2/core/services/push_notification_service.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<ApiService>(() => ApiService());

  sl.registerLazySingleton<AuthSessionService>(() => AuthSessionService());

  sl.registerLazySingleton<AppStartupService>(() => AppStartupService());

  sl.registerLazySingleton<FavoritesService>(() => FavoritesService());
  sl.registerLazySingleton(() => NavigationService());

  sl.registerLazySingleton<PushNotificationService>(
    () => PushNotificationService(),
  );
}
