part of '../orders_imports.dart';

class OrdersEmptyView extends StatelessWidget {
  const OrdersEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No orders found'),
    );
  }
}
