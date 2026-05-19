import 'package:almasry_2/core/core_imports.dart';
import 'package:almasry_2/features/favorites/favorites_imports.dart';
import 'package:almasry_2/features/splash/splash_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/auth/auth_imports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  await EasyLocalization.ensureInitialized();
  await SharedPrefsHelper.init();

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<StartupCubit>(create: (_) => StartupCubit()),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<FavoritesCubit>(
          create: (_) => FavoritesCubit()..loadFavorites(),
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
