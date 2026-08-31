import 'package:almasry_2/core/models/response/product_details/product_detail_model.dart';

class GetProductDetailResponse {
  final ProductDetailModel? product;

  const GetProductDetailResponse({this.product});

  factory GetProductDetailResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> items =
        (json['products'] as Map<String, dynamic>?)?['items']
            as List<dynamic>? ??
        const [];

    final List<Map<String, dynamic>> parsed = items
        .whereType<Map<String, dynamic>>()
        .toList();

    return GetProductDetailResponse(
      product: parsed.isEmpty
          ? null
          : ProductDetailModel.fromJson(parsed.first),
    );
  }
}
