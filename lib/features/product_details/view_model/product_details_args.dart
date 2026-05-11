class ProductDetailsArgs {
  final String imagePath;
  final String title;
  final String price;
  final String category;
  final String description;
  final double rating;

  const ProductDetailsArgs({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.rating,
  });
}
