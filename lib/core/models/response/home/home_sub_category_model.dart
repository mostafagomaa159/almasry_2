class HomeSubCategoryModel {
  final String id;
  final String parentId;
  final String name;
  final String image;
  final String categoryColor;
  final int productCount;

  const HomeSubCategoryModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.image,
    required this.categoryColor,
    required this.productCount,
  });

  factory HomeSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeSubCategoryModel(
      id: json['id']?.toString() ?? '',
      parentId: json['parentId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      categoryColor: json['category_color']?.toString() ?? '',
      productCount: int.tryParse(json['productCount']?.toString() ?? '0') ?? 0,
    );
  }
}
