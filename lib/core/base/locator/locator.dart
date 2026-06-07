import 'package:almasry_2/core/constants/app_api.dart';
import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/features/auth/auth_imports.dart';
import 'package:almasry_2/features/home/home_imports.dart';
import 'package:almasry_2/features/orders/orders_imports.dart';
import 'package:almasry_2/features/product_details/product_details_imports.dart';
import 'package:almasry_2/features/product_list/product_list_imports.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

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
  sl.registerFactory<OrderDetailsCubit>(
        () => OrderDetailsCubit(sl<ApiService>()),
  );

}
