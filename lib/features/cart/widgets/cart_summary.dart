part of '../cart_imports.dart';

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
      onAction: vm._navToCheckout,
    );
  }
}
