part of '../checkout_review_imports.dart';

class CheckoutReviewSummary extends StatelessWidget {
  final CheckoutReviewViewModel vm;
  final CartModel cart;

  const CheckoutReviewSummary({
    super.key,
    required this.vm,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._placingOrderCubit,
      builder: (BuildContext context, GenericState<bool> state) {
        return CartTotalsCard(
          subtotal: cart.subtotal,
          shippingCost: cart.shippingCost,
          discount: cart.discountTotal,
          grandTotal: cart.grandTotal,
          actionTitle: LocaleKeys.checkoutGoToPayment.tr(),
          onAction: vm._placeOrder,
          isLoading: state.data,
        );
      },
    );
  }
}
