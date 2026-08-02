import 'package:almasry_2/core/models/response/home/home_sub_category_model.dart';

class HomeMobileBlockModel {
  final String title;
  final String categoryId;
  final String seeAll;
  final bool loadProducts;
  final bool loadImagesWithTitle;
  final bool showMoreLoadProducts;
  final List<HomeSubCategoryModel> subCategories;

  const HomeMobileBlockModel({
    required this.title,
    required this.categoryId,
    required this.seeAll,
    required this.loadProducts,
    required this.loadImagesWithTitle,
    required this.showMoreLoadProducts,
    required this.subCategories,
  });

  factory HomeMobileBlockModel.fromJson(Map<String, dynamic> json) {
    return HomeMobileBlockModel(
      title: json['title']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      seeAll: json['seeAll']?.toString() ?? '',
      loadProducts: json['loadProducts'] ?? false,
      loadImagesWithTitle: json['loadImagesWithTitle'] ?? false,
      showMoreLoadProducts: json['showMoreLoadProducts'] ?? false,
      subCategories: (json['subCategories'] as List<dynamic>? ?? [])
          .map((e) => HomeSubCategoryModel.fromJson(e))
          .toList(),
    );
  }
}
