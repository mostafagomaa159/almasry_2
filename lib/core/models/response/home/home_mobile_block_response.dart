part of '../../../core_imports.dart';

class HomeMobileBlockResponse {
  final String title;
  final String categoryId;
  final String seeAll;
  final bool loadProducts;
  final bool loadImagesWithTitle;
  final bool showMoreLoadProducts;
  final List<HomeSubCategoryResponse> subCategories;

  const HomeMobileBlockResponse({
    required this.title,
    required this.categoryId,
    required this.seeAll,
    required this.loadProducts,
    required this.loadImagesWithTitle,
    required this.showMoreLoadProducts,
    required this.subCategories,
  });

  factory HomeMobileBlockResponse.fromJson(Map<String, dynamic> json) {
    return HomeMobileBlockResponse(
      title: json['title']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      seeAll: json['seeAll']?.toString() ?? '',
      loadProducts: json['loadProducts'] ?? false,
      loadImagesWithTitle: json['loadImagesWithTitle'] ?? false,
      showMoreLoadProducts: json['showMoreLoadProducts'] ?? false,
      subCategories: (json['subCategories'] as List<dynamic>? ?? [])
          .map((e) => HomeSubCategoryResponse.fromJson(e))
          .toList(),
    );
  }
}
