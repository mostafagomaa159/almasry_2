part of '../checkout_payment_imports.dart';

class CheckoutPaymentSummary extends StatelessWidget {
  final CheckoutPaymentViewModel vm;
  final CartModel cart;

  const CheckoutPaymentSummary({
    super.key,
    required this.vm,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._submittingCubit,
      builder: (context, submittingState) {
        return CartTotalsCard(
          subtotal: cart.subtotal,
          shippingCost: cart.shippingCost,
          discount: cart.discountTotal,
          grandTotal: cart.grandTotal,
          actionTitle: LocaleKeys.checkoutOrderReview.tr(),
          onAction: vm._proceed,
          isLoading: submittingState.data,
        );
      },
    );
  }
}
