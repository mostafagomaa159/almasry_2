part of '../core_imports.dart';

class AppLogo {
  static String asset(BuildContext context) {
    return context.locale.languageCode == 'ar'
        ? AppImages.logoAr
        : AppImages.logoEn;
  }
}
