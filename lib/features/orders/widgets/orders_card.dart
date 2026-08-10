part of '../orders_imports.dart';

class OrderCard extends StatelessWidget {
  final OrdersViewModel vm;
  final OrderModel order;

  const OrderCard({super.key, required this.vm, required this.order});

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
                  '${LocaleKeys.orderNumber.tr()}${order.incrementId}',
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
          10.verticalSpace,
          Text(
            order.createdAt,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
          ),
          12.verticalSpace,
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
                      : AppNetworkImage(
                          url: firstItem.productImage,
                          placeholder: const Icon(
                            Icons.image_not_supported_outlined,
                          ),
                        ),
                ),
                12.horizontalSpace,
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
          14.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.itemsCount.tr(args: ['${order.totalItemCount}']),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Text(
                '${LocaleKeys.currencyShort.tr()} ${order.grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF18314F),
                ),
              ),
            ],
          ),
          14.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => vm._openOrderDetails(order),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                elevation: 0,
              ),
              child: Text(LocaleKeys.details.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
