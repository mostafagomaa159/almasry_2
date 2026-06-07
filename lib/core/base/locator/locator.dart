part of '../../core_imports.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<Dio>(
        () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConstants.token}',
        },
      ),
    ),
  );

  sl.registerLazySingleton<ApiService>(
        () => ApiService(sl<Dio>()),
  );

  sl.registerFactory<HomeCubit>(
        () => HomeCubit(sl<ApiService>()),
  );

  sl.registerFactory<ProductDetailsCubit>(
        () => ProductDetailsCubit(sl<ApiService>()),
  );

  sl.registerFactory<AuthCubit>(
        () => AuthCubit(sl<ApiService>()),
  );

  sl.registerFactory<ProductListCubit>(
        () => ProductListCubit(sl<ApiService>()),
  );

  sl.registerFactory<OrdersCubit>(
        () => OrdersCubit(sl<ApiService>()),
  );
}
