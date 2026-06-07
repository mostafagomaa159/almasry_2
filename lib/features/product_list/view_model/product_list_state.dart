part of '../product_list_imports.dart';

enum ProductListStatus {
  initial,
  loading,
  success,
  error,
}

class ProductListState extends Equatable {
  final ProductListStatus status;
  final List<ProductResponse> products;
  final String errorMessage;
  final String title;
  final String categoryId;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.errorMessage = '',
    this.title = '',
    this.categoryId = '',
  });

  ProductListState copyWith({
    ProductListStatus? status,
    List<ProductResponse>? products,
    String? errorMessage,
    String? title,
    String? categoryId,
    bool clearErrorMessage = false,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: clearErrorMessage ? '' : (errorMessage ?? this.errorMessage),
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    errorMessage,
    title,
    categoryId,
  ];
}
