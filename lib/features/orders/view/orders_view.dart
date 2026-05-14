part of '../orders_imports.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF6F6F6),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                OrdersHeader(
                  onBackTap: () => context.pop(),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      16.w,
                      12.h,
                      16.w,
                      20.h,
                    ),
                    itemBuilder: (context, index) {
                      final order = state.orders[index];

                      return OrdersCard(
                        order: order,
                        onDetailsTap: () {
                          context.pushNamed(
                            'orderDetails',
                            extra: OrderDetailsArgs(
                              orderId: order.id,
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, _) => SizedBox(height: 16.h),
                    itemCount: state.orders.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
