import 'package:almasry_2/core/constants/app_stores.dart';

class LanguageDetector {
  LanguageDetector._();

  static final RegExp _arabic = RegExp(r'[؀-ۿݐ-ݿࢠ-ࣿﭐ-﷿ﹰ-﻿]');

  static final RegExp _latin = RegExp(r'[a-zA-Z]');

  static bool isArabic(String text) => _arabic.hasMatch(text);

  static bool isLatin(String text) => _latin.hasMatch(text);

  static bool? startsArabic(String text) {
    for (final int rune in text.runes) {
      final String character = String.fromCharCode(rune);

      if (_arabic.hasMatch(character)) return true;
      if (_latin.hasMatch(character)) return false;
    }

    return null;
  }

  static bool hasMixedLanguage(String text) {
    if (text.trim().isEmpty) return false;

    return isArabic(text) && isLatin(text);
  }

  static String storeCodeFor(String text) =>
      isArabic(text) ? AppStores.arabic : AppStores.defaultView;
}
