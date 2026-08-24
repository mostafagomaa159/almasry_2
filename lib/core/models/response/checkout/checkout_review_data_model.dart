part of '../../../../features/checkout_review/checkout_review_imports.dart';

/// Which of the three review sections are open, plus the place-order flight.
///
/// The design opens with all three expanded and lets each collapse
/// independently, so these are three flags rather than one selected index.
class CheckoutReviewData extends Equatable {
  final bool isProductsExpanded;
  final bool isOrderDetailsExpanded;
  final bool isBillExpanded;
  final bool isPlacingOrder;

  const CheckoutReviewData({
    this.isProductsExpanded = true,
    this.isOrderDetailsExpanded = true,
    this.isBillExpanded = true,
    this.isPlacingOrder = false,
  });

  CheckoutReviewData copyWith({
    bool? isProductsExpanded,
    bool? isOrderDetailsExpanded,
    bool? isBillExpanded,
    bool? isPlacingOrder,
  }) {
    return CheckoutReviewData(
      isProductsExpanded: isProductsExpanded ?? this.isProductsExpanded,
      isOrderDetailsExpanded:
          isOrderDetailsExpanded ?? this.isOrderDetailsExpanded,
      isBillExpanded: isBillExpanded ?? this.isBillExpanded,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
    );
  }

  @override
  List<Object?> get props => [
    isProductsExpanded,
    isOrderDetailsExpanded,
    isBillExpanded,
    isPlacingOrder,
  ];
}
