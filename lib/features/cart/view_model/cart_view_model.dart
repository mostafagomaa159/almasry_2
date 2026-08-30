part of '../cart_imports.dart';

class CartViewModel {
  final CartService _cartService = sl<CartService>();
  final NavigationService _navService = sl<NavigationService>();
  final AlertService _alertService = sl<AlertService>();

  late final GenericCubit<CartData> _cartCubit = _cartService.cartCubit;

  /// The payload, on the other hand, has to be read on every call — it is
  /// whatever the service last emitted.
  CartData _data() => _cartService.data;

  Future<void> _init() => _cartService.loadCart();

  void _dispose() {}

  Future<void> _refresh() => _cartService.refresh();

  Future<void> _retry() => _cartService.loadCart();

  Future<void> _increment(CartItemModel item) {
    return _cartService.updateQuantity(item: item, quantity: item.quantity + 1);
  }

  Future<void> _decrement(CartItemModel item) async {
    final bool isRemoving = item.quantity <= 1;

    final bool succeeded = await _cartService.updateQuantity(
      item: item,
      quantity: item.quantity - 1,
    );

    if (succeeded && isRemoving) {
      _alertService.showSuccess(LocaleKeys.cartItemRemoved.tr());
    }
  }

  void _buy() {
    if (_data().cart.isEmpty) return;

    _navService.pushNamed(RouteNames.checkoutShipping);
  }
}
