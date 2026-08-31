part of '../checkout_shipping_imports.dart';

class CheckoutShippingSummary extends StatelessWidget {
  final CheckoutShippingViewModel vm;

  const CheckoutShippingSummary({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<CartModel>, GenericState<CartModel>>(
      bloc: vm._cartCubit,
      builder: (BuildContext context, GenericState<CartModel> state) {
        final CartModel cart = state.data;

        return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
          bloc: vm._applyingAddressCubit,
          builder: (BuildContext context, GenericState<bool> applyingState) {
            return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
              bloc: vm._settingMethodCubit,
              builder: (BuildContext context, GenericState<bool> methodState) {
                return CartTotalsCard(
                  subtotal: cart.subtotal,
                  shippingCost: cart.shippingCost,
                  discount: cart.discountTotal,
                  grandTotal: cart.grandTotal,
                  actionTitle: LocaleKeys.checkoutProceedToPayment.tr(),
                  onAction: vm._proceed,
                  isLoading: applyingState.data || methodState.data,
                );
              },
            );
          },
        );
      },
    );
  }
}
