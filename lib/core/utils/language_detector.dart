/// Tells Arabic text from Latin text, so a search can be sent to the matching
/// Magento store view.
///
/// A shopper typing "بانادول panadol" is querying both stores at once, and
/// neither one alone would return the full set — [hasMixedLanguage] is what
/// flags that case.
class LanguageDetector {
  LanguageDetector._();

  static final RegExp _arabic = RegExp(r'[؀-ۿݐ-ݿࢠ-ࣿﭐ-﷿ﹰ-﻿]');

  static final RegExp _latin = RegExp(r'[a-zA-Z]');

  static bool isArabic(String text) => _arabic.hasMatch(text);

  static bool isLatin(String text) => _latin.hasMatch(text);

  static bool hasMixedLanguage(String text) {
    if (text.trim().isEmpty) return false;

    return isArabic(text) && isLatin(text);
  }

  static String storeHeaderFor(String text) => isArabic(text) ? 'arabic' : '';
}
