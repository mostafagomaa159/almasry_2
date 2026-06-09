part of '../my_order_imports.dart';

class OrderCard extends StatelessWidget {
  final OrderResponse order;

  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final firstItem = order.firstItem;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order #${order.incrementId}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF18314F),
                  ),
                ),
              ),
              OrderStatusChip(status: order.status),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            order.createdAt,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 12.h),
          if (firstItem != null)
            Row(
              children: [
                Container(
                  width: 58.w,
                  height: 58.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: firstItem.productImage.isEmpty
                      ? const Icon(Icons.image_not_supported_outlined)
                      : Image.network(
                    firstItem.productImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    firstItem.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF18314F),
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${order.totalItemCount} item(s)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Text(
                'L.E ${order.grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF18314F),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push(
                  AppRoutes.orderDetails,
                  extra: OrderDetailsArgs(
                    orderId: order.entityId,
                    incrementId: order.incrementId,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(

                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                elevation: 0,
              ),
              child: const Text('Details'),
            ),
          ),
        ],
      ),
    );
  }
}
