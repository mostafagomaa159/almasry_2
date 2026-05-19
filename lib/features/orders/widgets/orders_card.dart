part of '../orders_imports.dart';

class OrdersCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onDetailsTap;

  const OrdersCard({
    super.key,
    required this.order,
    required this.onDetailsTap,
  });

  String _formatPrice(double value, BuildContext context) {
    return '${value.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(12.w, 14.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox()),
              OrdersStatusBadge(status: order.status),
              Expanded(
                child: Text(
                  '${LocaleKeys.orderNumber.tr()} ${order.id}',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF17375E),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          ...order.items.map(
            (item) => Padding(
              padding: EdgeInsetsDirectional.only(bottom: 10.h),
              child: OrdersItemRow(item: item),
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Text(
                _formatPrice(order.total, context),
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF17375E),
                ),
              ),
              const Spacer(),
              Text(
                LocaleKeys.totalAmount.tr(),
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF17375E),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          const Divider(color: Color(0xFF8FA2B7), thickness: 1, height: 1),
          SizedBox(height: 12.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              onTap: onDetailsTap,
              child: Text(
                LocaleKeys.orderDetails.tr(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF3B30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
