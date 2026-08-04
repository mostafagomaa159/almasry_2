import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/localization/app_locale.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/response/favorite/favorites_model.dart';
import 'package:almasry_2/core/routing/app_router.dart';
import 'package:almasry_2/core/services/favorites_service.dart';
import 'package:almasry_2/core/services/push_background_services.dart';
import 'package:almasry_2/core/services/push_notification_service.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:almasry_2/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await setupServiceLocator();
  await EasyLocalization.ensureInitialized();
  await SharedPrefsServices.init();

  await sl<PushNotificationService>().init();

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
    final favoritesService = sl<FavoritesService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<GenericCubit<FavoritesModel>>.value(
          value: favoritesService.favoritesCubit,
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp.router(
          title: LocaleKeys.title.tr(),
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
