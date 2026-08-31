import 'package:almasry_2/core/models/response/cart/cart_money_model.dart';

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

  String get key => '$carrierCode|$methodCode';

  String get displayTitle =>
      carrierTitle.trim().isNotEmpty ? carrierTitle : methodTitle;

  double get price => priceInclTax.isZero ? amount.value : priceInclTax.value;

  bool get isEmpty => carrierCode.isEmpty || methodCode.isEmpty;
}
