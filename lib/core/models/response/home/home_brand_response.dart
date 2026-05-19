class HomeBrandResponse {
  final String id;
  final String name;
  final String image;

  const HomeBrandResponse({
    required this.id,
    required this.name,
    required this.image,
  });

  factory HomeBrandResponse.fromJson(Map<String, dynamic> json) {
    return HomeBrandResponse(
      id: json['id']?.toString() ?? '',
      name: (json['Name']?.toString().isNotEmpty ?? false)
          ? json['Name'].toString()
          : json['title']?.toString() ?? '',
      image: json['Image']?.toString() ?? '',
    );
  }
}
