/// The `{ value, currency }` money shape the whole cart schema uses.
///
/// The cart has its own copy rather than reusing `ProductPriceModel`: that one
/// is a `part`-free library but belongs to the catalogue payload, and the two
/// drift independently.
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
