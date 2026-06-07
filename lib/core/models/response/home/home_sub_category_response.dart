class HomeSubCategoryResponse {
  final String id;
  final String parentId;
  final String name;
  final String image;
  final String categoryColor;
  final int productCount;

  const HomeSubCategoryResponse({
    required this.id,
    required this.parentId,
    required this.name,
    required this.image,
    required this.categoryColor,
    required this.productCount,
  });

  factory HomeSubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return HomeSubCategoryResponse(
      id: json['id']?.toString() ?? '',
      parentId: json['parentId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      categoryColor: json['category_color']?.toString() ?? '',
      productCount: int.tryParse(json['productCount']?.toString() ?? '0') ?? 0,
    );
  }
}
