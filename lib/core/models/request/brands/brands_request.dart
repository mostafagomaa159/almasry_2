class BrandsRequest {
  final int page;
  final int pageSize;
  final String searchQuery;

  const BrandsRequest({
    required this.page,
    required this.pageSize,
    this.searchQuery = '',
  });

  Map<String, dynamic> toVariables() {
    return {
      'page': page,
      'pageSize': pageSize,
      if (searchQuery.trim().isNotEmpty) 'q': searchQuery.trim(),
    };
  }
}
