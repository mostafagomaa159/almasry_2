class ProductSearchRequest {
  final String searchText;
  final int pageSize;
  final int currentPage;

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
