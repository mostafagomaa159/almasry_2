part of '../checkout_payment_imports.dart';

class CheckoutPaymentSummary extends StatelessWidget {
  final CheckoutPaymentViewModel vm;

  const CheckoutPaymentSummary({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<CartModel>, GenericState<CartModel>>(
      bloc: vm._cartCubit,
      builder: (BuildContext context, GenericState<CartModel> state) {
        final CartModel cart = state.data;

        return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
          bloc: vm._submittingCubit,
          builder: (BuildContext context, GenericState<bool> submittingState) {
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
      },
    );
  }
}
