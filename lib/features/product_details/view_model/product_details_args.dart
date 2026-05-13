class ProductDetailsArgs {
  final String productId;
  final String imagePath;
  final String title;
  final String price;
  final String oldPrice;
  final String category;
  final String description;
  final double rating;

  const ProductDetailsArgs({
    required this.productId,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.description,
    required this.rating,
  });
}
