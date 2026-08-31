import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

String formatPrice(double value) {
  return '${LocaleKeys.currencyShort.tr()} ${value.toStringAsFixed(2)}';
}
