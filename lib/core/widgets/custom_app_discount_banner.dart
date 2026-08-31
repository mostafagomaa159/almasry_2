import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppDiscountBanner extends StatelessWidget {
  final int percent;

  final double borderRadius;

  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const CustomAppDiscountBanner({
    super.key,
    required this.percent,
    this.borderRadius = 6,
    this.backgroundColor = AppColors.borderSoft,
    this.textColor = AppColors.strongGrey,
    this.fontSize = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius == 0
            ? null
            : BorderRadius.circular(borderRadius.r),
      ),
      child: Text(
        LocaleKeys.getDiscount.tr(args: ['$percent']),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
