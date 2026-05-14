part of '../orders_imports.dart';


class OrdersStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrdersStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDelivered = status == OrderStatus.delivered;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: isDelivered
            ? const Color(0xFF54D38A)
            : const Color(0xFFF5B942),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isDelivered
                ? LocaleKeys.orderDelivered.tr()
                : LocaleKeys.orderPending.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 5.w),
          Icon(
            isDelivered ? Icons.check_circle : Icons.access_time_filled,
            color: Colors.white,
            size: 16.sp,
          ),
        ],
      ),
    );
  }
}
