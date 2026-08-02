import 'package:easy_localization/easy_localization.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/response/edit_profile/edit_profile_args_model.dart';
import 'package:almasry_2/core/models/response/my_orders_details/order_details_args_model.dart';
import 'package:almasry_2/core/models/response/product_details/product_details_args_model.dart';
import 'package:almasry_2/core/models/response/product_list/product_list_args_model.dart';
import 'package:almasry_2/core/models/response/login/otp_verification_args_model.dart';
import 'package:almasry_2/core/models/response/profile/profile_args_model.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/features/categories/categories_imports.dart';
import 'package:almasry_2/features/coming_soon/view/coming_soon_view.dart';
import 'package:almasry_2/features/edit_profile/edit_profile_imports.dart';
import 'package:almasry_2/features/home/home_imports.dart';
import 'package:almasry_2/features/login/login_imports.dart';
import 'package:almasry_2/features/my_order_details/my_order_imports.dart';
import 'package:almasry_2/features/orders/orders_imports.dart';
import 'package:almasry_2/features/otp_verification/otp_verification_imports.dart';
import 'package:almasry_2/features/product_details/product_details_imports.dart';
import 'package:almasry_2/features/product_list/product_list_imports.dart';
import 'package:almasry_2/features/profile/profile_imports.dart';
import 'package:almasry_2/features/register/register_imports.dart';
import 'package:almasry_2/features/splash/splash_imports.dart';
import 'package:almasry_2/features/wishlist/wishlist_imports.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        name: RouteNames.otpVerification,
        builder: (context, state) {
          final args = state.extra as OtpVerificationArgs;
          return OtpVerificationView(args: args);
        },
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: RouteNames.signup,
        builder: (context, state) => const RegisterCustomerView(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LayoutShellView(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: RouteNames.home,
                builder: (context, state) {
                  final ProfileArgs? args = state.extra as ProfileArgs?;
                  return HomeView(args: args);
                },
                routes: [
                  GoRoute(
                    path: 'productList',
                    name: RouteNames.productList,
                    builder: (context, state) {
                      final args = state.extra as ProductListArgs;
                      return ProductListView(
                        title: args.title,
                        categoryId: args.categoryId,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'productDetails',
                    name: RouteNames.productDetails,
                    builder: (context, state) {
                      final args = state.extra as ProductDetailsArgs;
                      return ProductDetailsView(args: args);
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.categories,
                name: RouteNames.categories,
                builder: (context, state) => const CategoriesView(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.comingsoonview,
                name: RouteNames.comingSoon,
                builder: (context, state) =>
                    ComingSoonView(title: LocaleKeys.cart.tr()),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: RouteNames.profile,
                builder: (context, state) {
                  final ProfileArgs? args = state.extra as ProfileArgs?;
                  return ProfileView(args: args);
                },
                routes: [
                  GoRoute(
                    path: AppRoutes.orders.replaceFirst('/', ''),
                    name: RouteNames.orders,
                    builder: (context, state) {
                      final email = state.extra as String;
                      return OrdersView(customerEmail: email);
                    },
                  ),
                  GoRoute(
                    path: AppRoutes.orderDetails.replaceFirst('/', ''),
                    name: RouteNames.orderDetails,
                    builder: (context, state) {
                      final args = state.extra as OrderDetailsArgs;
                      return OrderDetailsView(args: args);
                    },
                  ),
                  GoRoute(
                    path: AppRoutes.wishlist.replaceFirst('/', ''),
                    name: RouteNames.wishlist,
                    builder: (context, state) => const WishlistView(),
                  ),
                  GoRoute(
                    path: AppRoutes.editProfile.replaceFirst('/', ''),
                    name: RouteNames.editProfile,
                    builder: (context, state) {
                      final args = state.extra as EditProfileArgs?;
                      return EditProfileView(args: args);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
