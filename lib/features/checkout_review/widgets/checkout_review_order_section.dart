part of '../checkout_review_imports.dart';

/// "Order Details" — where it ships, who ships it, how it is paid. All three
/// are read off the cart, which is what Magento will actually use.
class CheckoutReviewOrderSection extends StatelessWidget {
  final CheckoutReviewViewModel vm;
  final CheckoutReviewData data;

  const CheckoutReviewOrderSection({
    super.key,
    required this.vm,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return CheckoutReviewSection(
      title: LocaleKeys.checkoutOrderDetails.tr(),
      isExpanded: data.isOrderDetailsExpanded,
      onToggle: vm._toggleOrderDetails,
      child: Column(
        children: <Widget>[
          CheckoutReviewRow(
            label: LocaleKeys.checkoutShippingAddress.tr(),
            value: vm._shippingAddressLine(),
          ),
          CheckoutReviewRow(
            label: LocaleKeys.checkoutShippingCompany.tr(),
            value: vm._shippingCompanyLine(),
          ),
          CheckoutReviewRow(
            label: LocaleKeys.checkoutPaymentMethod.tr(),
            value: vm._paymentMethodLine(),
          ),
        ],
      ),
    );
  }
}
