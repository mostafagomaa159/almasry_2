part of '../orders_imports.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderDetailsArgs args;

  const OrderDetailsPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderDetailsCubit>()
        ..loadOrderDetails(orderId: args.orderId.toString()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order #${args.incrementId}'),
        ),
        body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
          builder: (context, state) {
            switch (state.status) {
              case OrderDetailsStatus.initial:
              case OrderDetailsStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              case OrderDetailsStatus.error:
                return Center(
                  child: Text(state.errorMessage),
                );

              case OrderDetailsStatus.success:
                final order = state.order;

                if (order == null) {
                  return const Center(
                    child: Text('No order details found'),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _SectionCard(
                      title: 'Order Summary',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${order.status.name}'),
                          const SizedBox(height: 8),
                          Text('Date: ${order.createdAt}'),
                          const SizedBox(height: 8),
                          Text('Grand Total: ${order.total.toStringAsFixed(2)} EGP'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Items',
                      child: Column(
                        children: [
                          ...order.items.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == order.items.length - 1 ? 0 : 12,
                              ),
                              child: _OrderItemTile(item: item),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
