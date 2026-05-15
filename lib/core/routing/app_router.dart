import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/features/auth/auth_imports.dart';
import 'package:almasry_2/features/edit_profile/view_model/edit_profile_args.dart';
import 'package:almasry_2/features/home/home_imports.dart';
import 'package:almasry_2/features/profile/profile_imports.dart';
import 'package:almasry_2/features/profile/view_model/profile_args.dart';
import 'package:almasry_2/features/splash/splash_imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/edit_profile/edit_profile_imports.dart';
import '../../features/order_details/order_details_imports.dart';
import '../../features/order_details/view_model/order_details_args.dart';
import '../../features/orders/orders_imports.dart';
import '../../features/product_details/product_details_imports.dart';
import '../../features/product_details/view_model/product_details_args.dart';
import '../../features/wishlist/wishlist_imports.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.logOut,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          final ProfileArgs? args = state.extra as ProfileArgs?;
          return HomeScreen(args: args);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) {
          final ProfileArgs? args = state.extra as ProfileArgs?;
          return ProfileScreen(args: args);
        },
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'editProfile',
        builder: (context, state) {
          final args = state.extra as EditProfileArgs?;

          return BlocProvider(
            create: (_) => EditProfileCubit()..initialize(args),
            child: EditProfileView(args: args),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.orders,
        name: 'orders',
        builder: (context, state) => BlocProvider(
          create: (_) => OrdersCubit(),
          child: const OrdersView(),
        ),
      ),
      GoRoute(
        path: '/order-details',
        name: 'orderDetails',
        builder: (context, state) {
          final args = state.extra as OrderDetailsArgs;

          return BlocProvider(
            create: (_) => OrderDetailsCubit()..loadOrderDetails(args.orderId),
            child: const OrderDetailsView(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.productDetails,
        builder: (context, state) {
          final args = state.extra as ProductDetailsArgs;
          return ProductDetailsView(args: args);
        },
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        builder: (context, state) => const WishlistScreen(),
      ),




    ],
  );
}
