part of '../order_confirmed_imports.dart';

class OrderConfirmedViewModel {
  final _navService = sl<NavigationService>();

  final _prefs = sl<SharedPrefsServices>();

  OrderConfirmedArgs? _args;

  OrderConfirmedArgs _data() =>
      _args ?? const OrderConfirmedArgs(orderNumber: '', grandTotal: 0);

  void _init({required OrderConfirmedArgs args}) {
    _args = args;
  }

  void _openOrders() {
    _navService.goNamed(
      RouteNames.orders,
      extra: _prefs.getString(PrefKeys.email),
    );
  }

  void _backToMain() {
    _navService.goNamed(RouteNames.home);
  }
}
