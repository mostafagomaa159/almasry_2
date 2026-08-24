part of '../checkout_review_imports.dart';

/// The totals panel whose action places the order.
class CheckoutReviewSummary extends StatelessWidget {
  final CheckoutReviewViewModel vm;
  final CheckoutReviewData data;
  final CartModel cart;

  const CheckoutReviewSummary({
    super.key,
    required this.vm,
    required this.data,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return CartTotalsCard(
      subtotal: cart.subtotal,
      shippingCost: cart.shippingCost,
      discount: cart.discountTotal,
      grandTotal: cart.grandTotal,
      actionTitle: LocaleKeys.checkoutGoToPayment.tr(),
      onAction: vm._placeOrder,
      isLoading: data.isPlacingOrder,
    );
  }
}
