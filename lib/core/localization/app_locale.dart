import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_stores.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppLocale {
  const AppLocale._();

  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  static const List<Locale> supportedLocales = [english, arabic];

  static const String _fallback = AppStores.arabicLanguageCode;

  static SharedPrefsServices get _prefs => sl<SharedPrefsServices>();

  static String get languageCode =>
      _prefs.getString(PrefKeys.languageCode, defaultValue: _fallback);

  static bool get isArabic => languageCode == AppStores.arabicLanguageCode;

  static String get storeCode => AppStores.forLanguage(languageCode);

  static Future<void> setLanguage(BuildContext context, String code) async {
    if (context.locale.languageCode == code && languageCode == code) return;

    await context.setLocale(Locale(code));
    await _prefs.setString(PrefKeys.languageCode, code);
  }

  static Future<void> toggleLanguage(BuildContext context) {
    return setLanguage(
      context,
      isArabic ? AppStores.englishLanguageCode : AppStores.arabicLanguageCode,
    );
  }

  static Future<void> syncFrom(Locale locale) async {
    if (_prefs.getString(PrefKeys.languageCode) == locale.languageCode) return;

    await _prefs.setString(PrefKeys.languageCode, locale.languageCode);
  }
}
