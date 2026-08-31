import 'package:almasry_2/core/models/response/cart/cart_money_model.dart';

class CartAmountLineModel {
  final String label;
  final CartMoneyModel amount;

  const CartAmountLineModel({
    this.label = '',
    this.amount = const CartMoneyModel(),
  });

  factory CartAmountLineModel.fromJson(Map<String, dynamic> json) {
    return CartAmountLineModel(
      label: json['label']?.toString() ?? '',
      amount: CartMoneyModel.fromJson(json['amount'] as Map<String, dynamic>?),
    );
  }
}

class CartPricesModel {
  final CartMoneyModel grandTotal;
  final CartMoneyModel subtotalExcludingTax;
  final CartMoneyModel subtotalIncludingTax;
  final List<CartAmountLineModel> discounts;
  final List<CartAmountLineModel> appliedTaxes;

  const CartPricesModel({
    this.grandTotal = const CartMoneyModel(),
    this.subtotalExcludingTax = const CartMoneyModel(),
    this.subtotalIncludingTax = const CartMoneyModel(),
    this.discounts = const [],
    this.appliedTaxes = const [],
  });

  factory CartPricesModel.fromJson(Map<String, dynamic>? json) {
    return CartPricesModel(
      grandTotal: CartMoneyModel.fromJson(
        json?['grand_total'] as Map<String, dynamic>?,
      ),
      subtotalExcludingTax: CartMoneyModel.fromJson(
        json?['subtotal_excluding_tax'] as Map<String, dynamic>?,
      ),
      subtotalIncludingTax: CartMoneyModel.fromJson(
        json?['subtotal_including_tax'] as Map<String, dynamic>?,
      ),
      discounts: _lines(json?['discounts']),
      appliedTaxes: _lines(json?['applied_taxes']),
    );
  }

  static List<CartAmountLineModel> _lines(dynamic raw) {
    return (raw as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(CartAmountLineModel.fromJson)
        .toList();
  }

  double get subtotal => subtotalIncludingTax.isZero
      ? subtotalExcludingTax.value
      : subtotalIncludingTax.value;

  double get discountTotal =>
      discounts.fold(0, (sum, line) => sum + line.amount.value);

  double get taxTotal =>
      appliedTaxes.fold(0, (sum, line) => sum + line.amount.value);
}
