part of '../orders_imports.dart';

class OrdersListView extends StatelessWidget {
  final OrdersViewModel vm;
  final List<OrderModel> orders;

  const OrdersListView({super.key, required this.vm, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: orders.length,
      separatorBuilder: (_, _) => 12.verticalSpace,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(vm: vm, order: order);
      },
    );
  }
}
