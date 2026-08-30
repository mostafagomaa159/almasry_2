part of '../checkout_shipping_imports.dart';

/// The totals panel with the "Proceed to Payment" action.
///
/// Reads the cart rather than the screen's own state: once a shipping method
/// is set, Magento re-quotes the grand total with delivery in it, and the cart
/// is the thing that got re-read. The spinner is the two in-flight flags —
/// applying an address and setting a method are one wait to the user.
class CheckoutShippingSummary extends StatelessWidget {
  final CheckoutShippingViewModel vm;

  const CheckoutShippingSummary({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<CartData>, GenericState<CartData>>(
      bloc: vm._cartCubit,
      builder: (BuildContext context, GenericState<CartData> state) {
        final CartModel cart = state.data.cart;

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
