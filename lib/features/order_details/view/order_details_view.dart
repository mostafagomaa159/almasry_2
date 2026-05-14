part of '../order_details_imports.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  String _formatPrice(BuildContext context, double value) {
    return '${value.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
      builder: (context, state) {
        final order = state.orderDetails;

        return Scaffold(
          backgroundColor: const Color(0xFFF2F2F2),
          body: SafeArea(
            top: false,
            child: order == null
                ? const SizedBox.shrink()
                : Column(
              children: [
                OrderDetailsHeader(
                  onBackTap: () => context.pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      16.w,
                      14.h,
                      16.w,
                      24.h,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              OrdersStatusBadge(status: order.status),
                              const Spacer(),
                              Text(
                                '${LocaleKeys.orderNumber.tr()} ${order.orderId}',
                                style: TextStyle(
                                  color: const Color(0xFF17375E),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        const Divider(
                          color: Color(0xFFB9B9B9),
                          thickness: 1,
                          height: 1,
                        ),
                        SizedBox(height: 14.h),
                        OrderDetailsInfoSection(
                          customerName: order.customerName,
                          phoneNumber: order.phoneNumber,
                          address: order.address,
                        ),
                        SizedBox(height: 14.h),
                        const Divider(
                          color: Color(0xFFB9B9B9),
                          thickness: 1,
                          height: 1,
                        ),
                        SizedBox(height: 14.h),
                        ...order.items.map(
                              (item) => Padding(
                            padding: EdgeInsetsDirectional.only(
                              bottom: 16.h,
                            ),
                            child: OrderDetailsProductItem(item: item),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        OrderDetailsSummaryRow(
                          title: LocaleKeys.subtotal.tr(),
                          value: _formatPrice(context, order.subtotal),
                        ),
                        SizedBox(height: 12.h),
                        OrderDetailsSummaryRow(
                          title: LocaleKeys.shippingFees.tr(),
                          value: _formatPrice(context, order.shipping),
                        ),
                        SizedBox(height: 12.h),
                        const Divider(
                          color: Color(0xFFB9B9B9),
                          thickness: 1,
                          height: 1,
                        ),
                        SizedBox(height: 12.h),
                        OrderDetailsSummaryRow(
                          title: LocaleKeys.discount.tr(),
                          value: _formatPrice(context, order.discount),
                        ),
                        SizedBox(height: 12.h),
                        OrderDetailsSummaryRow(
                          title: LocaleKeys.totalAmount.tr(),
                          value: _formatPrice(context, order.total),
                          isBold: true,
                        ),
                        SizedBox(height: 26.h),
                        OrderDetailsReorderButton(
                          onTap: () {},
                        ),
                      ],
                    ),
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
