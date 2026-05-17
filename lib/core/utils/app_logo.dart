part of '../core_imports.dart';

class AppLogo {
  static String asset(BuildContext context) {
    return context.locale.languageCode == 'ar'
        ? 'assets/images/Almasry-AR.png'
        : 'assets/images/Almasry-EN.png';
  }
}
