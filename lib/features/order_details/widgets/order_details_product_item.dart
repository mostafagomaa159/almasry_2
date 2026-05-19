part of '../order_details_imports.dart';

class OrderDetailsProductItem extends StatelessWidget {
  final OrderItemModel item;

  const OrderDetailsProductItem({super.key, required this.item});

  String _formatPrice(BuildContext context, double value) {
    return '${value.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.name,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: const Color(0xFF17375E),
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                _formatPrice(context, item.price),
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: const Color(0xFF17375E),
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          width: 84.w,
          height: 84.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Image.asset(item.imagePath, fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}
