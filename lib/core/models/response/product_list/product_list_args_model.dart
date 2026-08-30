class ProductListArgs {
  final String title;

  final String categoryId;

  final bool isBrand;

  const ProductListArgs({
    required this.title,
    required this.categoryId,
    this.isBrand = false,
  });
}
