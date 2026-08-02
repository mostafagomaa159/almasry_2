import 'package:almasry_2/core/models/response/product_list/product_model.dart';

class ProductListModel {
  final List<ProductModel> items;
  final int totalCount;

  const ProductListModel({required this.items, required this.totalCount});
}
