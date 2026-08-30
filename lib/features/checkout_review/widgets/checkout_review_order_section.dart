part of '../checkout_review_imports.dart';

/// "Order Details" — where it ships, who ships it, how it is paid. All three
/// are read off the cart, which is what Magento will actually use.
class CheckoutReviewOrderSection extends StatelessWidget {
  final CheckoutReviewViewModel vm;

  const CheckoutReviewOrderSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._orderExpandedCubit,
      builder: (BuildContext context, GenericState<bool> state) {
        return CheckoutReviewSection(
          title: LocaleKeys.checkoutOrderDetails.tr(),
          isExpanded: state.data,
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
      },
    );
  }
}
