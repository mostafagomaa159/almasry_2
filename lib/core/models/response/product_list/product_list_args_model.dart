class ProductListArgs {
  final String title;

  /// A category id, or a brand id when [isBrand] is true.
  final String categoryId;

  /// Set by the brands screen so the list filters on the brand attribute
  /// instead of the category tree.
  final bool isBrand;

  const ProductListArgs({
    required this.title,
    required this.categoryId,
    this.isBrand = false,
  });
}
