
class ProductCustomAttributeResponse {
  final String attributeCode;
  final dynamic value;

  const ProductCustomAttributeResponse({
    required this.attributeCode,
    required this.value,
  });

  factory ProductCustomAttributeResponse.fromJson(Map<String, dynamic> json) {
    return ProductCustomAttributeResponse(
      attributeCode: json['attribute_code']?.toString() ?? '',
      value: json['value'],
    );
  }
}
