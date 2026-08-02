part of '../../../../features/product_list/product_list_imports.dart';

enum ProductListStatus { initial, loading, success, error }

class ProductListData extends Equatable {
  final ProductListStatus status;
  final List<ProductModel> products;
  final String errorMessage;
  final String title;
  final String categoryId;
  final int currentPage;
  final bool isLoadingMore;
  final bool hasMore;
  final int totalCount;
  final Map<String, int> quantities;

  const ProductListData.ProductListModel({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.errorMessage = '',
    this.title = '',
    this.categoryId = '',
    this.currentPage = 1,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.totalCount = 0,
    this.quantities = const {},
  });

  ProductListData copyWith({
    ProductListStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
    String? title,
    String? categoryId,
    int? currentPage,
    bool? isLoadingMore,
    bool? hasMore,
    int? totalCount,
    Map<String, int>? quantities,
    bool clearErrorMessage = false,
    bool resetProducts = false,
    bool resetQuantities = false,
  }) {
    return ProductListData.ProductListModel(
      status: status ?? this.status,
      products: resetProducts ? [] : (products ?? this.products),
      errorMessage: clearErrorMessage
          ? ''
          : (errorMessage ?? this.errorMessage),
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
      quantities: resetQuantities ? {} : (quantities ?? this.quantities),
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    errorMessage,
    title,
    categoryId,
    currentPage,
    isLoadingMore,
    hasMore,
    totalCount,
    quantities,
  ];
}
