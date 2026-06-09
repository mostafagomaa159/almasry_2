part of '../orders_imports.dart';

class OrdersListView extends StatelessWidget {
  final List<OrderResponse> orders;
  final Future<void> Function() onRefresh;

  const OrdersListView({
    super.key,
    required this.orders,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: orders.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(order: order);
        },
      ),
    );
  }
}
