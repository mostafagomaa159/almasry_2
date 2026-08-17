import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_stores.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// The app's current language, readable **without a [BuildContext]**.
///
/// `easy_localization` owns the locale but only hands it out through a context,
/// which the context-free services — [GraphQLService] above all — cannot reach.
/// So the language code is mirrored into prefs here, and everything that has no
/// context reads it from [languageCode] or [storeCode].
///
/// Route every language change through [setLanguage] rather than calling
/// `context.setLocale` directly, so the mirror can never fall behind. [syncFrom]
/// is the safety net for the locale `easy_localization` restores on its own at
/// launch.
class AppLocaleService {
  final SharedPrefsServices _prefs = sl<SharedPrefsServices>();

  /// Matches `main()`'s `startLocale`, so a fresh install reports the language
  /// it is actually about to show.
  static const String _fallback = AppStores.arabicLanguageCode;

  String get languageCode =>
      _prefs.getString(PrefKeys.languageCode, defaultValue: _fallback);

  bool get isArabic => languageCode == AppStores.arabicLanguageCode;

  /// The Magento store view the current language maps to.
  String get storeCode => AppStores.forLanguage(languageCode);

  /// Switches the app's language and mirrors it in one step.
  Future<void> setLanguage(BuildContext context, String code) async {
    if (context.locale.languageCode == code && languageCode == code) return;

    await context.setLocale(Locale(code));
    await _prefs.setString(PrefKeys.languageCode, code);
  }

  Future<void> toggleLanguage(BuildContext context) {
    return setLanguage(
      context,
      isArabic ? AppStores.englishLanguageCode : AppStores.arabicLanguageCode,
    );
  }

  /// Brings the mirror in line with a locale the app did not set itself —
  /// the one `easy_localization` restores at launch. A no-op once they agree.
  Future<void> syncFrom(Locale locale) async {
    if (_prefs.getString(PrefKeys.languageCode) == locale.languageCode) return;

    await _prefs.setString(PrefKeys.languageCode, locale.languageCode);
  }
}
