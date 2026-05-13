import 'package:almasry_2/features/orders/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../order_details/order_details.dart';

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
