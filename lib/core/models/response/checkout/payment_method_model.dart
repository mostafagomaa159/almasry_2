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
