part of '../my_order_imports.dart';

class OrderDetailsArgs {
  final int orderId;
  final String incrementId;

  const OrderDetailsArgs({required this.orderId, required this.incrementId});
}

class OrderDetailsView extends StatefulWidget {
  final OrderDetailsArgs args;

  const OrderDetailsView({super.key, required this.args});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  late final OrderDetailsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = OrderDetailsViewModel()
      ..init(orderId: widget.args.orderId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #${widget.args.incrementId}')),
      body:
          BlocBuilder<
            GenericCubit<OrderDetailsModel>,
            GenericState<OrderDetailsModel>
          >(
            bloc: viewModel.orderDetailsCubit,
            builder: (context, state) {
              final data = state.data;

              if (data.isLoading && data.order == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (data.errorMessage != null && data.order == null) {
                return Center(child: Text(data.errorMessage!));
              }

              final order = data.order;

              if (order == null) {
                return const Center(child: Text('No order details found'));
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
                        Text(
                          'Grand Total: ${order.total.toStringAsFixed(2)} EGP',
                        ),
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
            },
          ),
    );
  }
}
