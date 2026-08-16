/// Variables for [GraphQLDocuments.productsByBrand].
class ProductsByBrandRequest {
  final String brandId;
  final int pageSize;

  const ProductsByBrandRequest({required this.brandId, this.pageSize = 10});

  Map<String, dynamic> toVariables() {
    return {'brandId': brandId.trim(), 'pageSize': pageSize};
  }
}
