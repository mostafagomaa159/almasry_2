part of '../../../../features/product_details/product_details_imports.dart';

class ProductDetailsModel extends Equatable {
  final bool isLoading;
  final ProductModel? product;
  final String? errorMessage;
  final int quantity;

  const ProductDetailsModel({
    this.isLoading = false,
    this.product,
    this.errorMessage,
    this.quantity = 1,
  });

  ProductDetailsModel copyWith({
    bool? isLoading,
    ProductModel? product,
    String? errorMessage,
    int? quantity,
    bool clearProduct = false,
    bool clearErrorMessage = false,
  }) {
    return ProductDetailsModel(
      isLoading: isLoading ?? this.isLoading,
      product: clearProduct ? null : (product ?? this.product),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [isLoading, product, errorMessage, quantity];
}
