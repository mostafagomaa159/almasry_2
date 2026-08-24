import 'package:almasry_2/core/models/response/cart/cart_money_model.dart';

/// A row of `shipping_addresses.available_shipping_methods`, and also the
/// shape `selected_shipping_method` comes back in — the selected one simply
/// omits the price breakdown, which parses to zero.
class ShippingMethodModel {
  final String carrierCode;
  final String carrierTitle;
  final String methodCode;
  final String methodTitle;
  final bool available;
  final CartMoneyModel amount;
  final CartMoneyModel priceInclTax;

  const ShippingMethodModel({
    required this.carrierCode,
    required this.methodCode,
    this.carrierTitle = '',
    this.methodTitle = '',
    this.available = true,
    this.amount = const CartMoneyModel(),
    this.priceInclTax = const CartMoneyModel(),
  });

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) {
    return ShippingMethodModel(
      carrierCode: json['carrier_code']?.toString() ?? '',
      methodCode: json['method_code']?.toString() ?? '',
      carrierTitle: json['carrier_title']?.toString() ?? '',
      methodTitle: json['method_title']?.toString() ?? '',
      available: json['available'] as bool? ?? true,
      amount: CartMoneyModel.fromJson(json['amount'] as Map<String, dynamic>?),
      priceInclTax: CartMoneyModel.fromJson(
        json['price_incl_tax'] as Map<String, dynamic>?,
      ),
    );
  }

  /// `carrier_code`/`method_code` is the only pair that identifies a method,
  /// so it doubles as the radio group's value.
  String get key => '$carrierCode|$methodCode';

  /// The carrier title, not the method title: this store quotes
  /// `carrier_title: "Best Way"` with `method_title: "Table Rate"`, and the
  /// design shows "Best Way".
  String get displayTitle =>
      carrierTitle.trim().isNotEmpty ? carrierTitle : methodTitle;

  double get price => priceInclTax.isZero ? amount.value : priceInclTax.value;

  bool get isEmpty => carrierCode.isEmpty || methodCode.isEmpty;
}
