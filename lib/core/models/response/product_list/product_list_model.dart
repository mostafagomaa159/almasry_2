import 'package:almasry_2/core/models/response/home/product_response.dart';

class ProductListPageModel {
  final List<ProductResponse> items;
  final int totalCount;

  const ProductListPageModel({
    required this.items,
    required this.totalCount,
  });
}
