class ProductDetailRequest {
  final String sku;

  const ProductDetailRequest({required this.sku});

  Map<String, dynamic> toVariables() => {'sku': sku.trim()};
}
