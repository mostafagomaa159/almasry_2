part of '../checkout_payment_imports.dart';

/// The totals panel with the "Order Review" action. Reads the cart, which by
/// this point in the flow already carries the shipping quote.
class CheckoutPaymentSummary extends StatelessWidget {
  final CheckoutPaymentViewModel vm;
  final CheckoutPaymentData data;

  const CheckoutPaymentSummary({
    super.key,
    required this.vm,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<CartData>, GenericState<CartData>>(
      bloc: vm._cartCubit,
      builder: (BuildContext context, GenericState<CartData> state) {
        final CartModel cart = state.data.cart;

        return CartTotalsCard(
          subtotal: cart.subtotal,
          shippingCost: cart.shippingCost,
          discount: cart.discountTotal,
          grandTotal: cart.grandTotal,
          actionTitle: LocaleKeys.checkoutOrderReview.tr(),
          onAction: vm._proceed,
          isLoading: data.isSubmitting,
        );
      },
    );
  }
}
