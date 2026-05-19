class FavoriteProductModel {
  final String id;
  final String title;
  final String imagePath;
  final String price;
  final String oldPrice;
  final String category;
  final String description;

  const FavoriteProductModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'price': price,
      'oldPrice': oldPrice,
      'category': category,
      'description': description,
    };
  }

  factory FavoriteProductModel.fromMap(Map<String, dynamic> map) {
    return FavoriteProductModel(
      id: map['id'] as String,
      title: map['title'] as String,
      imagePath: map['imagePath'] as String,
      price: map['price'] as String,
      oldPrice: map['oldPrice'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
    );
  }
}
