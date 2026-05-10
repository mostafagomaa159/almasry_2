import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/features/auth/auth.dart';
import 'package:almasry_2/features/edit_profile/view/edit_profile_view.dart';
import 'package:almasry_2/features/edit_profile/view_model/edit_profile_args.dart';
import 'package:almasry_2/features/edit_profile/view_model/edit_profile_cubit.dart';
import 'package:almasry_2/features/home/home.dart';
import 'package:almasry_2/features/profile/profile.dart';
import 'package:almasry_2/features/splash/splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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



    ],
  );
}
