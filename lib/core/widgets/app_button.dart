import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedBackgroundColor = backgroundColor ??
        (isPrimary ? AppColors.primaryRed : AppColors.white);

    final Color resolvedBorderColor =
        borderColor ?? (isPrimary ? AppColors.primaryRed : AppColors.darkBlue);

    final Color resolvedTextColor =
        textColor ?? (isPrimary ? AppColors.white : AppColors.darkBlue);

    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: resolvedBackgroundColor,
          disabledBackgroundColor: resolvedBackgroundColor,
          foregroundColor: resolvedTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius.r),
            side: BorderSide(
              color: resolvedBorderColor,
              width: 1.5.w,
            ),
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
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: resolvedTextColor,
          ),
        ),
      ),
    );
  }
}
