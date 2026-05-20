part of '../core_imports.dart';

final GetIt sl = GetIt.instance;

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> post({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post(
      endPoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get(
      endPoint,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

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
        },
      ),
    ),
  );

  sl.registerLazySingleton<ApiService>(
        () => ApiService(sl<Dio>()),
  );

  sl.registerLazySingleton<HomeRepository>(
        () => HomeRepository(sl<ApiService>()),
  );

  sl.registerLazySingleton<ProductsRepository>(
        () => ProductsRepository(sl<ApiService>()),
  );

  sl.registerFactory<HomeCubit>(
        () => HomeCubit(
      sl<HomeRepository>(),
      sl<ProductsRepository>(),
    ),
  );
  sl.registerFactory<ProductDetailsCubit>(
        () => ProductDetailsCubit(
      sl<ProductsRepository>(),
    ),
  );

}
