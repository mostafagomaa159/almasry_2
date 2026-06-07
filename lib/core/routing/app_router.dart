import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/features/auth/auth_imports.dart';
import 'package:almasry_2/features/auth/view_model/OtpVerificationArgs.dart';
import 'package:almasry_2/features/edit_profile/edit_profile_imports.dart';
import 'package:almasry_2/features/edit_profile/view_model/edit_profile_args.dart';
import 'package:almasry_2/features/home/home_imports.dart';
import 'package:almasry_2/features/orders/orders_imports.dart';
import 'package:almasry_2/features/product_details/product_details_imports.dart';
import 'package:almasry_2/features/product_details/view_model/product_details_args.dart';
import 'package:almasry_2/features/product_list/product_list_imports.dart';
import 'package:almasry_2/features/profile/profile_imports.dart';
import 'package:almasry_2/features/profile/view_model/profile_args.dart';
import 'package:almasry_2/features/splash/splash_imports.dart';
import 'package:almasry_2/features/wishlist/wishlist_imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.startup,
    routes: [
      GoRoute(
        path: AppRoutes.startup,
        builder: (context, state) => const StartupGate(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final args = state.extra as OtpVerificationArgs;
          return OtpVerificationScreen(args: args);
        },
      ),
      GoRoute(
        path: AppRoutes.productList,
        builder: (context, state) {
          final args = state.extra as ProductListArgs;
          return ProductListPage(
            title: args.title,
            categoryId: args.categoryId,
          );
        },
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
        builder: (context, state) {
          final email = state.extra as String;
          return OrdersPage(customerEmail: email);
        },
      ),
      GoRoute(
        path: AppRoutes.orderDetails,
        name: 'orderDetails',
        builder: (context, state) {
          final args = state.extra as OrderDetailsArgs;
          return OrderDetailsPage(args: args);
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
