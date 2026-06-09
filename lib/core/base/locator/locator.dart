import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/features/auth/auth_imports.dart';
import 'package:almasry_2/features/home/home_imports.dart';
import 'package:almasry_2/features/my_order_details/my_order_imports.dart';
import 'package:almasry_2/features/orders/orders_imports.dart';
import 'package:almasry_2/features/product_details/product_details_imports.dart';
import 'package:almasry_2/features/product_list/product_list_imports.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {


  sl.registerLazySingleton<ApiService>(
        () => ApiService(),
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

  sl.registerFactory<OrdersViewModel>(
        () => OrdersViewModel(sl<ApiService>()),
  );

  sl.registerFactory<OrderDetailsCubit>(
        () => OrderDetailsCubit(sl<ApiService>()),
  );

}
