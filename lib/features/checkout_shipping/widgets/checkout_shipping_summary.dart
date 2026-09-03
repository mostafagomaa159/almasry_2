part of '../checkout_shipping_imports.dart';

class CheckoutShippingSummary extends StatelessWidget {
  final CheckoutShippingViewModel vm;
  final CartModel cart;

  const CheckoutShippingSummary({
    super.key,
    required this.vm,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._applyingAddressCubit,
      builder: (context, applyingState) {
        return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
          bloc: vm._settingMethodCubit,
          builder: (context, methodState) {
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
  }
}
