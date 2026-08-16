part of '../../../../features/product_search/product_search_imports.dart';

/// [ProductSearchStatus.idle] is the screen before it has anything to show —
/// an empty box, or a query too short to send. It is what puts the recent
/// searches on screen, so it is not the same as an empty result set.
enum ProductSearchStatus { idle, loading, success, error }

class ProductSearchData extends Equatable {
  final ProductSearchStatus status;

  /// The text the results on screen belong to — not what the field currently
  /// holds, which changes on every keystroke.
  final String query;

  final List<ProductSearchProductModel> products;
  final List<String> recentSearches;
  final bool availableOnly;
  final bool isLoadingMore;
  final String errorMessage;
  final int totalCount;
  final int currentPage;

  const ProductSearchData({
    this.status = ProductSearchStatus.idle,
    this.query = '',
    this.products = const [],
    this.recentSearches = const [],
    this.availableOnly = false,
    this.isLoadingMore = false,
    this.errorMessage = '',
    this.totalCount = 0,
    this.currentPage = 1,
  });

  bool get hasMore => products.length < totalCount;

  ProductSearchData copyWith({
    ProductSearchStatus? status,
    String? query,
    List<ProductSearchProductModel>? products,
    List<String>? recentSearches,
    bool? availableOnly,
    bool? isLoadingMore,
    String? errorMessage,
    int? totalCount,
    int? currentPage,
    bool clearErrorMessage = false,
  }) {
    return ProductSearchData(
      status: status ?? this.status,
      query: query ?? this.query,
      products: products ?? this.products,
      recentSearches: recentSearches ?? this.recentSearches,
      availableOnly: availableOnly ?? this.availableOnly,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearErrorMessage
          ? ''
          : (errorMessage ?? this.errorMessage),
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    products,
    recentSearches,
    availableOnly,
    isLoadingMore,
    errorMessage,
    totalCount,
    currentPage,
  ];
}
