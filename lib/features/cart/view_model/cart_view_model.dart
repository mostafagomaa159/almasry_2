part of '../cart_imports.dart';

class CartViewModel {
  final _cartService = sl<CartService>();
  final _navService = sl<NavigationService>();
  final _alertService = sl<AlertService>();

  late final GenericCubit<CartModel> _cartCubit = _cartService.cartCubit;
  late final GenericCubit<bool> _loadingCubit = _cartService.loadingCubit;
  late final GenericCubit<Set<int>> _busyItemsCubit =
      _cartService.busyItemsCubit;

  Future<void> _init() => _cartService.loadCart();

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
    if (_cartService.cart.isEmpty) return;

    _navService.pushNamed(RouteNames.checkoutShipping);
  }
}
