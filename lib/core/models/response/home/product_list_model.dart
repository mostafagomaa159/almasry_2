
import 'package:almasry_2/core/models/response/home/product_item_response.dart';

class ProductListResponse {
  final List<ProductItemResponse> items;
  final int totalCount;

  const ProductListResponse({
    required this.items,
    required this.totalCount,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => ProductItemResponse.fromJson(e))
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
    );
  }
}
