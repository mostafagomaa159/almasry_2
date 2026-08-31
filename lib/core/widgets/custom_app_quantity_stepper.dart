import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppQuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  final double height;
  final double horizontalPadding;
  final double borderRadius;
  final Color borderColor;
  final Color? backgroundColor;

  final double buttonSize;
  final double iconSize;

  final double spacing;

  final double fontSize;
  final double numberMinWidth;

  final Color contentColor;
  final Color? iconColor;
  final Color disabledColor;

  final bool boxedButtons;

  final bool incrementFirst;

  const CustomAppQuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.height = 36,
    this.horizontalPadding = 4,
    this.borderRadius = 12,
    this.borderColor = AppColors.border,
    this.backgroundColor,
    this.buttonSize = 26,
    this.iconSize = 17,
    this.spacing = 8,
    this.fontSize = 15,
    this.numberMinWidth = 12,
    this.contentColor = AppColors.titleNavy,
    this.iconColor,
    this.disabledColor = AppColors.disabledGrey,
    this.boxedButtons = false,
    this.incrementFirst = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget plus = _button(icon: Icons.add, onTap: onIncrement);
    final Widget minus = _button(icon: Icons.remove, onTap: onDecrement);
    final Widget gap = SizedBox(width: spacing.w);

    return Container(
      height: height.h,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: incrementFirst
            ? [plus, gap, _number(), gap, minus]
            : [minus, gap, _number(), gap, plus],
      ),
    );
  }

  Widget _number() {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: numberMinWidth.w),
      child: Center(
        child: Text(
          '$quantity',
          style: TextStyle(
            fontSize: fontSize.sp,
            fontWeight: FontWeight.w700,
            color: contentColor,
          ),
        ),
      ),
    );
  }

  Widget _button({required IconData icon, required VoidCallback? onTap}) {
    final bool isDisabled = onTap == null;

    final Widget glyph = Icon(
      icon,
      size: iconSize.sp,
      color: isDisabled ? disabledColor : (iconColor ?? contentColor),
    );

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: boxedButtons
            ? Container(
                width: buttonSize.w,
                height: buttonSize.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDisabled ? AppColors.surfaceMuted : AppColors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isDisabled
                        ? AppColors.surfaceGrey
                        : AppColors.borderButton,
                  ),
                ),
                child: glyph,
              )
            : SizedBox(width: buttonSize.w, height: buttonSize.w, child: glyph),
      ),
    );
  }
}
