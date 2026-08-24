part of '../order_confirmed_imports.dart';

/// The confirmation screen. Everything on it arrives in [OrderConfirmedArgs],
/// so this ViewModel owns no cubit and makes no request — it only routes the
/// three ways out.
class OrderConfirmedViewModel {
  final NavigationService _nav = sl<NavigationService>();

  SharedPrefsServices get _prefs => sl<SharedPrefsServices>();

  OrderConfirmedArgs? _args;

  OrderConfirmedArgs get _data =>
      _args ?? const OrderConfirmedArgs(orderNumber: '', grandTotal: 0);

  void _init({required OrderConfirmedArgs args}) {
    _args = args;
  }

  void _dispose() {}

  /// `placeOrder` hands back an order number but no numeric id, and the order
  /// details route needs both — so both "Track order" and "Details" land on
  /// the orders list, where the new order is the first row.
  void _openOrders() {
    _nav.goNamed(RouteNames.orders, extra: _prefs.getString(PrefKeys.email));
  }

  void _backToMain() {
    _nav.goNamed(RouteNames.home);
  }
}
