part of '../cart_imports.dart';

class CartViewModel {
  final _cartService = sl<CartService>();
  final _alertService = sl<AlertService>();
  final _navService = sl<NavigationService>();

  late final GenericCubit<CartModel> _cartCubit = _cartService.cartCubit;

  CartModel _cart() => _cartService.cart;

  Future<void> _init() => _cartService.loadCart();

  Future<void> _refreshCart() => _cartService.loadCart();

  Future<void> _incrementQuantity(CartItemModel item) {
    return _cartService.updateQuantity(item: item, quantity: item.quantity + 1);
  }

  Future<void> _decrementQuantity(CartItemModel item) {
    return _cartService.updateQuantity(item: item, quantity: item.quantity - 1);
  }

  void _confirmRemoveItem(CartItemModel item) {
    _alertService.showConfirmation(
      title: LocaleKeys.cartRemoveConfirm.tr(),
      confirmTitle: LocaleKeys.confirm.tr(),
      cancelTitle: LocaleKeys.cancel.tr(),
      onConfirm: () => _removeItem(item),
    );
  }

  Future<void> _removeItem(CartItemModel item) async {
    final bool removed = await _cartService.removeItem(item);

    if (removed) _alertService.showSuccess(LocaleKeys.cartItemRemoved.tr());
  }

  void _navToCheckout() {
    if (_cart().isEmpty) return;

    _navService.pushNamed(RouteNames.checkout);
  }
}
