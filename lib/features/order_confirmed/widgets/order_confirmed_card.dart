part of '../order_confirmed_imports.dart';

/// The order summary card: number, status pill, grand total, and the link into
/// the order list.
class OrderConfirmedCard extends StatelessWidget {
  final OrderConfirmedViewModel vm;

  const OrderConfirmedCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final OrderConfirmedArgs data = vm._data();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  data.orderNumber,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),

              _StatusPill(status: data.status),
            ],
          ),

          14.verticalSpace,

          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  LocaleKeys.cartGrandTotal.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),

              Text(
                formatPrice(data.grandTotal),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryRed,
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 1.h, color: const Color(0xFFE2E2E2)),
          ),

          InkWell(
            onTap: vm._openOrders,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Text(
                LocaleKeys.orderConfirmedDetails.tr(),
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The dark pill beside the order number. Deliberately not the shared
/// `CustomOrderStatusChip`: that one is pastel-per-status and this design wants one
/// solid dark blue pill.
class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }
}
