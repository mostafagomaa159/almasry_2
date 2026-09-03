part of '../checkout_imports.dart';

class CheckoutReviewBillSection extends StatelessWidget {
  final CheckoutViewModel vm;
  final CartModel cart;

  const CheckoutReviewBillSection({
    super.key,
    required this.vm,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._billExpandedCubit,
      builder: (BuildContext context, GenericState<bool> state) {
        return CheckoutReviewSection(
          title: LocaleKeys.checkoutBillDetails.tr(),
          isExpanded: state.data,
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
      },
    );
  }
}
