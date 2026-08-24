import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

/// "L.E 281.00" — the one place that decides where the currency sits relative
/// to the number, so a cart row and a checkout total can never disagree.
///
/// The short currency label is localised (`L.E` / `ج.م`); the amount is not
/// run through `NumberFormat` because the design shows plain grouped-free
/// decimals in both languages.
String formatPrice(double value) {
  return '${LocaleKeys.currencyShort.tr()} ${value.toStringAsFixed(2)}';
}
