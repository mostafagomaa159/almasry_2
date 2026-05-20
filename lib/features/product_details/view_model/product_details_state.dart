part of '../product_details_imports.dart';

class ProductDetailsState {
  final bool isLoading;
  final ProductResponse? product;
  final String? errorMessage;
  final int quantity;

  const ProductDetailsState({
    this.isLoading = false,
    this.product,
    this.errorMessage,
    this.quantity = 1,
  });

  ProductDetailsState copyWith({
    bool? isLoading,
    ProductResponse? product,
    String? errorMessage,
    int? quantity,
    bool clearProduct = false,
    bool clearErrorMessage = false,
  }) {
    return ProductDetailsState(
      isLoading: isLoading ?? this.isLoading,
      product: clearProduct ? null : (product ?? this.product),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      quantity: quantity ?? this.quantity,
    );
  }
}
