part of '../../../core_imports.dart';


class HomeMobileBlockResponse {
  final String title;
  final String categoryId;
  final bool loadProducts;
  final bool loadImagesWithTitle;
  final List<HomeSubCategoryResponse> subCategories;

  const HomeMobileBlockResponse({
    required this.title,
    required this.categoryId,
    required this.loadProducts,
    required this.loadImagesWithTitle,
    required this.subCategories,
  });

  factory HomeMobileBlockResponse.fromJson(Map<String, dynamic> json) {
    return HomeMobileBlockResponse(
      title: json['title']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      loadProducts: json['loadProducts'] ?? false,
      loadImagesWithTitle: json['loadImagesWithTitle'] ?? false,
      subCategories: (json['subCategories'] as List<dynamic>? ?? [])
          .map((e) => HomeSubCategoryResponse.fromJson(e))
          .toList(),
    );
  }
}
