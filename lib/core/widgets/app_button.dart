import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;

  /// `false` greys the button out and drops its tap handler, without the
  /// spinner [isLoading] brings.
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double fontSize;
  final double elevation;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize = 18,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedBackgroundColor =
        backgroundColor ?? (isPrimary ? AppColors.primaryRed : AppColors.white);

    final Color resolvedBorderColor =
        borderColor ?? (isPrimary ? AppColors.primaryRed : AppColors.darkBlue);

    final Color resolvedTextColor =
        textColor ?? (isPrimary ? AppColors.white : AppColors.darkBlue);

    final double resolvedRadius = borderRadius ?? AppSizes.borderRadius;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppSizes.buttonHeight.h,
      child: ElevatedButton(
        onPressed: (isLoading || !isEnabled) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: resolvedBackgroundColor,
          disabledBackgroundColor: resolvedBackgroundColor,
          foregroundColor: resolvedTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(resolvedRadius.r),
            side: BorderSide(color: resolvedBorderColor, width: 1.5.w),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.white,
                ),
              )
            : Text(
                title,
                style: TextStyle(
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.w700,
                  color: resolvedTextColor,
                ),
              ),
      ),
    );
  }
}
