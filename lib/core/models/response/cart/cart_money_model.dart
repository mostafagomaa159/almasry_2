class CartMoneyModel {
  final double value;
  final String currency;

  const CartMoneyModel({this.value = 0, this.currency = ''});

  factory CartMoneyModel.fromJson(Map<String, dynamic>? json) {
    return CartMoneyModel(
      value: (json?['value'] as num?)?.toDouble() ?? 0,
      currency: json?['currency']?.toString() ?? '',
    );
  }

  bool get isZero => value <= 0;
}
