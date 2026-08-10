part of '../../../../features/brands/brands_imports.dart';

enum BrandsStatus { initial, loading, success, error }

class BrandsData extends Equatable {
  final BrandsStatus status;
  final List<BrandModel> brands;
  final String errorMessage;
  final String searchQuery;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final bool isLoadingMore;

  const BrandsData({
    this.status = BrandsStatus.initial,
    this.brands = const [],
    this.errorMessage = '',
    this.searchQuery = '',
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalCount = 0,
    this.isLoadingMore = false,
  });

  bool get hasMore => currentPage < totalPages;

  BrandsData copyWith({
    BrandsStatus? status,
    List<BrandModel>? brands,
    String? errorMessage,
    String? searchQuery,
    int? currentPage,
    int? totalPages,
    int? totalCount,
    bool? isLoadingMore,
    bool clearErrorMessage = false,
    bool resetBrands = false,
  }) {
    return BrandsData(
      status: status ?? this.status,
      brands: resetBrands ? const [] : (brands ?? this.brands),
      errorMessage: clearErrorMessage
          ? ''
          : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    brands,
    errorMessage,
    searchQuery,
    currentPage,
    totalPages,
    totalCount,
    isLoadingMore,
  ];
}
