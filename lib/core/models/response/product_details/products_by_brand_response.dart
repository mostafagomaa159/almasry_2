import 'package:almasry_2/core/models/response/product_details/product_related_item_model.dart';

class ProductsByBrandResponse {
  final List<ProductRelatedItemModel> items;
  final int totalCount;

  const ProductsByBrandResponse({this.items = const [], this.totalCount = 0});

  factory ProductsByBrandResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? products =
        json['products'] as Map<String, dynamic>?;

    return ProductsByBrandResponse(
      items: (products?['items'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProductRelatedItemModel.fromJson)
          .toList(),
      totalCount: (products?['total_count'] as num?)?.toInt() ?? 0,
    );
  }
}
