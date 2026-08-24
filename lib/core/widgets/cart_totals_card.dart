import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/utils/price_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The grey totals panel pinned to the bottom of the cart and of all three
/// checkout steps, with that screen's primary action inside it.
///
/// A null [shippingCost] drops the shipping row entirely — the cart quotes no
/// shipping until a method has been picked, and showing "L.E 0.00" there would
/// read as free delivery.
class CartTotalsCard extends StatelessWidget {
  final double subtotal;
  final double? shippingCost;
  final double discount;
  final double grandTotal;
  final String actionTitle;
  final VoidCallback? onAction;
  final bool isLoading;

  const CartTotalsCard({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.grandTotal,
    required this.actionTitle,
    required this.onAction,
    this.shippingCost,
    this.isLoading = false,
  });

  static const Color _background = Color(0xFFF2F2F2);
  static const Color _labelColor = Color(0xFF3B3B3B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _background,
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 14.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _TotalsRow(label: LocaleKeys.cartSubTotal.tr(), value: subtotal),

          if (shippingCost != null) ...<Widget>[
            6.verticalSpace,
            _TotalsRow(
              label: LocaleKeys.cartShippingCosts.tr(),
              value: shippingCost!,
            ),
          ],

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(height: 1.h, color: const Color(0xFFD6D6D6)),
          ),

          _TotalsRow(label: LocaleKeys.cartDiscount.tr(), value: discount),

          6.verticalSpace,

          _TotalsRow(label: LocaleKeys.cartGrandTotal.tr(), value: grandTotal),

          14.verticalSpace,

          SizedBox(
            width: double.infinity,
            height: 58.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: onAction == null && !isLoading
                    ? const Color(0xFFE0A0A0)
                    : AppColors.primaryRed,
                disabledForegroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      actionTitle,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  final String label;
  final double value;

  const _TotalsRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: CartTotalsCard._labelColor,
    );

    return Row(
      children: <Widget>[
        Expanded(child: Text(label, style: style)),
        Text(formatPrice(value), style: style),
      ],
    );
  }
}
