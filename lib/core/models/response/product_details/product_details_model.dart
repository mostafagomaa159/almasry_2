part of '../product_details_imports.dart';


class ProductDetailsData extends Equatable {
  final bool isLoading;
  final ProductModel? product;
  final String? errorMessage;
  final int quantity;

  const ProductDetailsData({
    this.isLoading = false,
    this.product,
    this.errorMessage,
    this.quantity = 1,
  });

  ProductDetailsData copyWith({
    bool? isLoading,
    ProductModel? product,
    String? errorMessage,
    int? quantity,
    bool clearProduct = false,
    bool clearErrorMessage = false,
  }) {
    return ProductDetailsData(
      isLoading: isLoading ?? this.isLoading,
      product: clearProduct ? null : (product ?? this.product),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    product,
    errorMessage,
    quantity,
  ];
}
