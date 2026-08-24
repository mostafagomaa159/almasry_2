part of '../cart_imports.dart';

/// Drives the cart screen. The cart itself belongs to `CartService` — the
/// bottom bar badge and the checkout read the same state — so this ViewModel
/// owns no cubit of its own: it reads the service's and translates taps into
/// mutations on it.
///
/// That is also why [_dispose] closes nothing. Closing the service cubit here
/// would take the badge and every later screen down with the screen.
class CartViewModel {
  final CartService _cart = sl<CartService>();
  final NavigationService _nav = sl<NavigationService>();
  final AlertService _alert = sl<AlertService>();

  GenericCubit<CartData> get _cartCubit => _cart.cartCubit;

  CartData get _data => _cart.data;

  Future<void> _init() => _cart.loadCart();

  void _dispose() {}

  Future<void> _refresh() => _cart.refresh();

  Future<void> _retry() => _cart.loadCart();

  Future<void> _increment(CartItemModel item) {
    return _cart.updateQuantity(item: item, quantity: item.quantity + 1);
  }

  /// The minus button on the last unit removes the line — which is what
  /// `CartService.updateQuantity` does with a quantity of 0.
  Future<void> _decrement(CartItemModel item) async {
    final bool isRemoving = item.quantity <= 1;

    final bool succeeded = await _cart.updateQuantity(
      item: item,
      quantity: item.quantity - 1,
    );

    if (succeeded && isRemoving) {
      _alert.showSuccess(LocaleKeys.cartItemRemoved.tr());
    }
  }

  void _buy() {
    if (_data.cart.isEmpty) return;

    _nav.pushNamed(RouteNames.checkoutShipping);
  }
}
