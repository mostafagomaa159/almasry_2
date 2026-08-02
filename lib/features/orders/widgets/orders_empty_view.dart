part of '../orders_imports.dart';

class OrdersEmptyView extends StatelessWidget {
  const OrdersEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(LocaleKeys.ordersNotFound.tr()));
  }
}
