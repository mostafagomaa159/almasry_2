import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/localization/app_locale.dart';
import 'package:almasry_2/core/models/response/favorite/favorites_model.dart';
import 'package:almasry_2/core/routing/app_router.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:almasry_2/features/splash/splash_imports.dart';
import 'package:almasry_2/features/wishlist/wishlist_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/auth/auth_imports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  await EasyLocalization.ensureInitialized();
  await SharedPrefsServices.init();

  runApp(
    EasyLocalization(
      supportedLocales: AppLocale.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: AppLocale.english,
      startLocale: AppLocale.arabic,
      child: const BlinkApp(),
    ),
  );
}

class BlinkApp extends StatelessWidget {
  const BlinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = sl<AuthViewModel>();
    final startupViewModel = sl<SplashViewModel>();
    final favoritesViewModel = sl<FavoritesViewModel>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<GenericCubit<SplashData>>.value(
          value: startupViewModel.splashCubit,
        ),
        BlocProvider<GenericCubit<UserModel>>.value(
          value: authViewModel.authCubit,
        ),
        BlocProvider<GenericCubit<FavoritesModel>>.value(
          value: favoritesViewModel.favoritesCubit,
        ),

      ],
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp.router(
          title: 'Al Masry',
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
