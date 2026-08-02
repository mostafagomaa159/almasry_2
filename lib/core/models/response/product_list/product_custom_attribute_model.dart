class ProductCustomAttributeModel {
  final String attributeCode;
  final dynamic value;

  const ProductCustomAttributeModel({
    required this.attributeCode,
    required this.value,
  });

  factory ProductCustomAttributeModel.fromJson(Map<String, dynamic> json) {
    return ProductCustomAttributeModel(
      attributeCode: json['attribute_code']?.toString() ?? '',
      value: json['value'],
    );
  }
}
