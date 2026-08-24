/// A sub-option of a payment method — the bank / installment provider the
/// design lists under the expandable "BankCards" and "installments" rows.
class PaymentOptionModel {
  final String code;
  final String name;
  final String logo;

  const PaymentOptionModel({
    required this.code,
    this.name = '',
    this.logo = '',
  });

  factory PaymentOptionModel.fromJson(Map<String, dynamic> json) {
    return PaymentOptionModel(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
    );
  }
}

/// A row of `cart.available_payment_methods`.
///
/// [options] is a store extension, not core Magento: a method with options is
/// drawn as an expandable row and its `selected_option` has to be sent with
/// the code.
class PaymentMethodModel {
  final String code;
  final String title;
  final List<PaymentOptionModel> options;

  const PaymentMethodModel({
    required this.code,
    this.title = '',
    this.options = const [],
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      options: (json['options'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(PaymentOptionModel.fromJson)
          .where((PaymentOptionModel option) => option.code.trim().isNotEmpty)
          .toList(),
    );
  }

  bool get hasOptions => options.isNotEmpty;
}
