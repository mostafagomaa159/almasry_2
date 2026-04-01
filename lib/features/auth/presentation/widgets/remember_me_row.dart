import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class RememberMeRow extends StatelessWidget {
  final bool isChecked;
  final String rememberMeTitle;
  final String forgotPasswordTitle;
  final VoidCallback onCheckboxTap;
  final VoidCallback? onForgotPasswordTap;

  const RememberMeRow({
    super.key,
    required this.isChecked,
    required this.rememberMeTitle,
    required this.forgotPasswordTitle,
    required this.onCheckboxTap,
    this.onForgotPasswordTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onCheckboxTap,
                child: Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: isChecked ? AppColors.primaryRed : AppColors.white,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: isChecked
                          ? AppColors.primaryRed
                          : AppColors.border,
                    ),
                  ),
                  child: isChecked
                      ? Icon(
                    Icons.check,
                    size: 20.sp,
                    color: AppColors.white,
                  )
                      : null,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                rememberMeTitle,
                style: TextStyle(
                  color: AppColors.primaryRed,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 22.h),
          GestureDetector(
            onTap: onForgotPasswordTap,
            child: Text(
              forgotPasswordTitle,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
