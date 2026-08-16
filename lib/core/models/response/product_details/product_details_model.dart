part of '../../../../features/product_details/product_details_imports.dart';

/// [ProductDetailsStatus.initial] is the screen before its first response —
/// what puts the shimmer up. A `success` with a null product means the SKU
/// matched nothing, which is the empty state, not an error.
enum ProductDetailsStatus { initial, loading, success, error }

class ProductDetailsData extends Equatable {
  final ProductDetailsStatus status;
  final ProductDetailModel? product;
  final String errorMessage;

  final int quantity;

  final bool isNotifySubscribed;
  final bool isNotifyLoading;

  final List<ProductRelatedItemModel> brandProducts;

  final bool isBrandProductsLoading;

  final bool isDescriptionExpanded;

  final int selectedImageIndex;

  const ProductDetailsData({
    this.status = ProductDetailsStatus.initial,
    this.product,
    this.errorMessage = '',
    this.quantity = 1,
    this.isNotifySubscribed = false,
    this.isNotifyLoading = false,
    this.brandProducts = const [],
    this.isBrandProductsLoading = false,
    this.isDescriptionExpanded = false,
    this.selectedImageIndex = 0,
  });

  ProductDetailsData copyWith({
    ProductDetailsStatus? status,
    ProductDetailModel? product,
    String? errorMessage,
    int? quantity,
    bool? isNotifySubscribed,
    bool? isNotifyLoading,
    List<ProductRelatedItemModel>? brandProducts,
    bool? isBrandProductsLoading,
    bool? isDescriptionExpanded,
    int? selectedImageIndex,
    bool clearProduct = false,
    bool clearErrorMessage = false,
  }) {
    return ProductDetailsData(
      status: status ?? this.status,
      product: clearProduct ? null : (product ?? this.product),
      errorMessage: clearErrorMessage
          ? ''
          : (errorMessage ?? this.errorMessage),
      quantity: quantity ?? this.quantity,
      isNotifySubscribed: isNotifySubscribed ?? this.isNotifySubscribed,
      isNotifyLoading: isNotifyLoading ?? this.isNotifyLoading,
      brandProducts: brandProducts ?? this.brandProducts,
      isBrandProductsLoading:
          isBrandProductsLoading ?? this.isBrandProductsLoading,
      isDescriptionExpanded:
          isDescriptionExpanded ?? this.isDescriptionExpanded,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
    );
  }

  @override
  List<Object?> get props => [
    status,
    product,
    errorMessage,
    quantity,
    isNotifySubscribed,
    isNotifyLoading,
    brandProducts,
    isBrandProductsLoading,
    isDescriptionExpanded,
    selectedImageIndex,
  ];
}
