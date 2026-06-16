import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/features/auth/auth_imports.dart';
import 'package:almasry_2/features/categories/categories_imports.dart';
import 'package:almasry_2/features/splash/splash_imports.dart';
import 'package:almasry_2/features/wishlist/wishlist_imports.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<ApiService>(
        () => ApiService(),
  );

  sl.registerLazySingleton<AuthViewModel>(
        () => AuthViewModel(),
  );

  sl.registerLazySingleton<StartupViewModel>(
        () => StartupViewModel(),
  );

  sl.registerLazySingleton<CategoriesViewModel>(
        () => CategoriesViewModel(sl<ApiService>()),
  );

  sl.registerLazySingleton<FavoritesViewModel>(
        () => FavoritesViewModel(),
  );
}
