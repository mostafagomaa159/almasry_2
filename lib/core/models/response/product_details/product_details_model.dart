part of '../../../../features/product_details/product_details_imports.dart';

class ProductDetailsModel extends Equatable {
  final bool isLoading;
  final ProductModel? product;
  final String? errorMessage;
  final int quantity;

  /// True once the user has asked to be notified about this product.
  final bool isNotifySubscribed;

  /// True while the notify-me request is in flight, so the button can show a
  /// spinner and reject a second tap.
  final bool isNotifyLoading;

  const ProductDetailsModel({
    this.isLoading = false,
    this.product,
    this.errorMessage,
    this.quantity = 1,
    this.isNotifySubscribed = false,
    this.isNotifyLoading = false,
  });

  ProductDetailsModel copyWith({
    bool? isLoading,
    ProductModel? product,
    String? errorMessage,
    int? quantity,
    bool? isNotifySubscribed,
    bool? isNotifyLoading,
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
      isNotifySubscribed: isNotifySubscribed ?? this.isNotifySubscribed,
      isNotifyLoading: isNotifyLoading ?? this.isNotifyLoading,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    product,
    errorMessage,
    quantity,
    isNotifySubscribed,
    isNotifyLoading,
  ];
}
