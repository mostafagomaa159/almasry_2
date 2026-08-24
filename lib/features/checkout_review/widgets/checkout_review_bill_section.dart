part of '../checkout_review_imports.dart';

/// "Bill details" — the breakdown that is not already in the totals panel
/// below it: tax, delivery and discount.
class CheckoutReviewBillSection extends StatelessWidget {
  final CheckoutReviewViewModel vm;
  final CheckoutReviewData data;
  final CartModel cart;

  const CheckoutReviewBillSection({
    super.key,
    required this.vm,
    required this.data,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return CheckoutReviewSection(
      title: LocaleKeys.checkoutBillDetails.tr(),
      isExpanded: data.isBillExpanded,
      onToggle: vm._toggleBill,
      child: Column(
        children: <Widget>[
          CheckoutReviewRow(
            label: LocaleKeys.checkoutTax.tr(),
            value: formatPrice(cart.taxTotal),
            isCompact: true,
          ),
          CheckoutReviewRow(
            label: LocaleKeys.cartShippingCosts.tr(),
            value: formatPrice(cart.shippingCost),
            isCompact: true,
          ),
          CheckoutReviewRow(
            label: LocaleKeys.cartDiscount.tr(),
            value: formatPrice(cart.discountTotal),
            isCompact: true,
          ),
        ],
      ),
    );
  }
}
