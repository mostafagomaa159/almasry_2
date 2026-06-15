//
// import 'package:almasry_2/core/models/response/home/product_item_model.dart';
//
// class ProductListModel {
//   final List<ProductItemModel> items;
//   final int totalCount;
//
//   const ProductListModel({
//     required this.items,
//     required this.totalCount,
//   });
//
//   factory ProductListModel.fromJson(Map<String, dynamic> json) {
//     return ProductListModel(
//       items: (json['items'] as List<dynamic>? ?? [])
//           .map((e) => ProductListModel.fromJson(e))
//           .toList(),
//       totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
//     );
//   }
// }
