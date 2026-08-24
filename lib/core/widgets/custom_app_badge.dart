import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A small filled pill of text — the order status chip, the merchandising
/// label over a product image, and anything else that is one word on a colour.
///
/// Both colours are required rather than defaulted: every caller derives them
/// from data (an order state, a CSS payload), so a default would only ever be
/// wrong.
class CustomAppBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final bool uppercase;
  final int? maxLines;

  const CustomAppBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.borderRadius = 20,
    this.horizontalPadding = 10,
    this.verticalPadding = 6,
    this.fontSize = 12,
    this.uppercase = false,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding.w,
        vertical: verticalPadding.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: Text(
        uppercase ? label.toUpperCase() : label,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

/// Kept beside [CustomAppBadge] because it is the same pill with a tap and a
/// selected state — the "available only" filter, and any chip added next to it.
class CustomAppChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  /// Grows a circular clear button at the leading edge once selected.
  final bool showClearWhenSelected;

  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color unselectedBorderColor;
  final double borderRadius;
  final double fontSize;

  const CustomAppChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.showClearWhenSelected = true,
    this.selectedColor = AppColors.primaryRed,
    this.unselectedColor = AppColors.white,
    this.selectedTextColor = AppColors.white,
    this.unselectedTextColor = AppColors.textPrimary,
    this.unselectedBorderColor = AppColors.border,
    this.borderRadius = 24,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(borderRadius.r);
    final bool withClear = isSelected && showClearWhenSelected;

    return Material(
      color: isSelected ? selectedColor : unselectedColor,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: EdgeInsetsDirectional.fromSTEB(
            withClear ? 8.w : 18.w,
            10.h,
            18.w,
            10.h,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: isSelected ? selectedColor : unselectedBorderColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (withClear) ...[
                Container(
                  width: 24.w,
                  height: 24.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.25),
                  ),
                  child: Icon(Icons.close, size: 15.sp, color: AppColors.white),
                ),
                8.horizontalSpace,
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
