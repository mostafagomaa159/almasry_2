part of '../cart_imports.dart';

/// The totals panel at the foot of the cart.
///
/// No shipping row here: nothing has been quoted yet at this point in the
/// flow, and the totals card drops the row when it is given no cost.
class CartSummary extends StatelessWidget {
  final CartViewModel vm;
  final CartModel cart;

  const CartSummary({super.key, required this.vm, required this.cart});

  @override
  Widget build(BuildContext context) {
    return CartTotalsCard(
      subtotal: cart.subtotal,
      discount: cart.discountTotal,
      grandTotal: cart.grandTotal,
      actionTitle: LocaleKeys.cartBuy.tr(),
      onAction: vm._buy,
    );
  }
}
