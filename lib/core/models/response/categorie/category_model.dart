
import 'package:almasry_2/core/constants/app_api.dart';

class CategoryModel {
  final int id;
  final int? parentId;
  final String name;
  final String image;
  final bool isActive;
  final int position;
  final int level;
  final int productCount;
  final String? description;
  final String? color;
  final List<CategoryModel> childrenData;

  const CategoryModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.image,
    required this.isActive,
    required this.position,
    required this.level,
    required this.productCount,
    required this.description,
    required this.color,
    required this.childrenData,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      parentId: json['parent_id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isActive: json['is_active'] ?? false,
      position: json['position'] ?? 0,
      level: json['level'] ?? 0,
      productCount: json['product_count'] ?? 0,
      description: json['description'],
      color: json['color'],
      childrenData: (json['children_data'] as List? ?? [])
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
    );
  }

  String get imageUrl {
    if (image.trim().isEmpty) return '';

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }

    return '${ApiConstants.mediaBaseUrl}$image';
  }
}
