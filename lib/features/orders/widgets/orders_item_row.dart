part of '../orders_imports.dart';

class OrdersItemRow extends StatelessWidget {
  final OrderItemModel item;

  const OrdersItemRow({
    super.key,
    required this.item,
  });

  String _formatPrice(double value, BuildContext context) {
    return '${value.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(top: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF17375E),
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  _formatPrice(item.price, context),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A2A2A),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Image.asset(
          item.imagePath,
          width: 86.w,
          height: 86.w,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
