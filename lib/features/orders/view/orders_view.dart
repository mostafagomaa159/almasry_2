part of '../orders_imports.dart';

class OrdersPage extends StatelessWidget {
  final String customerEmail;

  const OrdersPage({
    super.key,
    required this.customerEmail,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrdersCubit>()..loadOrders(email: customerEmail),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('My Orders'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state.status == OrdersStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == OrdersStatus.error) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    state.errorMessage,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state.orders.isEmpty) {
              return const Center(
                child: Text('No orders found'),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: state.orders.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return OrderCard(order: order);
              },
            );
          },
        ),
      ),
    );
  }
}
