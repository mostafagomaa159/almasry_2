import 'package:almasry_2/core/models/response/product_search/product_search_product_model.dart';


class ProductSearchResponse {
  final List<ProductSearchProductModel> items;
  final int totalCount;
  const ProductSearchResponse({required this.items, required this.totalCount});

  factory ProductSearchResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? products =
        json['products'] as Map<String, dynamic>?;
    final List<ProductSearchProductModel> items =
        (products?['items'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(ProductSearchProductModel.fromJson)
            .toList();
    return ProductSearchResponse(
      items: items,
      totalCount: (products?['total_count'] as num?)?.toInt() ?? 0,
    );
  }
}
