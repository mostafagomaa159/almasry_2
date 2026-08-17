import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The flat full-width bar that replaces a card's action row when the product
/// cannot be bought — "out of stock" today, and whatever else the catalogue
/// starts reporting later.
///
/// It takes an already-translated [label] rather than a status enum, because
/// the two call sites reach it from different models.
class CustomAppStatusBanner extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final double fontSize;

  const CustomAppStatusBanner({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.unavailableGrey,
    this.textColor = AppColors.white,
    this.height = 40,
    this.borderRadius = 10,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
