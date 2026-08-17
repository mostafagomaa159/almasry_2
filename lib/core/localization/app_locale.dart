import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_stores.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// The app's locales, and the current language read **without a
/// [BuildContext]**.
///
/// `easy_localization` owns the locale but only hands it out through a context,
/// which the context-free code — [GraphQLService] picking a store view — cannot
/// reach. So the language code is mirrored into prefs here.
///
/// Change the language through [setLanguage] rather than `context.setLocale`,
/// or the mirror falls behind.
class AppLocale {
  const AppLocale._();

  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  static const List<Locale> supportedLocales = [english, arabic];

  /// Matches `main()`'s `startLocale`, so a fresh install reports the language
  /// it is about to show.
  static const String _fallback = AppStores.arabicLanguageCode;

  static SharedPrefsServices get _prefs => sl<SharedPrefsServices>();

  static String get languageCode =>
      _prefs.getString(PrefKeys.languageCode, defaultValue: _fallback);

  static bool get isArabic => languageCode == AppStores.arabicLanguageCode;

  /// The Magento store view the current language maps to.
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

  /// Brings the mirror in line with a locale the app did not set itself — the
  /// one `easy_localization` restores at launch. A no-op once they agree.
  static Future<void> syncFrom(Locale locale) async {
    if (_prefs.getString(PrefKeys.languageCode) == locale.languageCode) return;

    await _prefs.setString(PrefKeys.languageCode, locale.languageCode);
  }
}
