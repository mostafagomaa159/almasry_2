class BrandModel {
  final String id;
  final String name;
  final String image;

  const BrandModel({required this.id, required this.name, required this.image});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  bool get hasImage => image.trim().isNotEmpty;
}
