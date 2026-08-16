/// Variables for [GraphQLDocuments.searchProducts].
///
/// [searchText] covers both search modes — a product name and a raw SKU go
/// into the same argument, so the screen never asks the user which one it is.
class ProductSearchRequest {
  final String searchText;
  final int pageSize;
  final int currentPage;

  /// Backs the "Available only" chip. When off the filter is omitted entirely
  /// rather than sent as `OUT_OF_STOCK`, so the response keeps both.
  final bool availableOnly;

  const ProductSearchRequest({
    required this.searchText,
    required this.pageSize,
    required this.currentPage,
    this.availableOnly = false,
  });

  Map<String, dynamic> toVariables() {
    return {
      'searchText': searchText.trim(),
      'pageSize': pageSize,
      'currentPage': currentPage,
      if (availableOnly)
        'filters': {
          'stock_status': {'eq': 'IN_STOCK'},
        },
    };
  }
}
