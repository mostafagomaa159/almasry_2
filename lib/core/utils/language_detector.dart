import 'package:almasry_2/core/constants/app_stores.dart';

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

  /// Whether the text *reads* right-to-left, by its first strong character.
  ///
  /// This is Unicode's first-strong rule, and it is what decides how a mixed
  /// run renders: "Panadol, فيتامين" reads left-to-right, "فيتامين, Panadol"
  /// reads right-to-left, even though [isArabic] is true for both.
  ///
  /// Returns `null` when there is no strong character at all — a weight, a
  /// price, a lone "—" — because those carry no direction of their own and
  /// should follow the interface instead.
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

  /// The store view a query should be sent to, judged by the text itself.
  ///
  /// Deliberately explicit about the default view rather than returning an
  /// empty string: [GraphQLService] now sends the *interface* language's store
  /// on every request, so "no override" would send a Latin query to the Arabic
  /// store whenever the app is in Arabic — and find nothing.
  static String storeCodeFor(String text) =>
      isArabic(text) ? AppStores.arabic : AppStores.defaultView;
}
