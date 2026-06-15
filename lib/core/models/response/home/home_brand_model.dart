class HomeBrandModel {
  final String id;
  final String name;
  final String image;

  const HomeBrandModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory HomeBrandModel.fromJson(Map<String, dynamic> json) {
    return HomeBrandModel(
      id: json['id']?.toString() ?? '',
      name: (json['Name']?.toString().isNotEmpty ?? false)
          ? json['Name'].toString()
          : json['title']?.toString() ?? '',
      image: json['Image']?.toString() ?? '',
    );
  }
}
