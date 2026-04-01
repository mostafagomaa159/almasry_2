import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class AuthToggleTabs extends StatelessWidget {
  final String rightTitle;
  final String leftTitle;
  final bool isRightSelected;
  final VoidCallback onRightTap;
  final VoidCallback onLeftTap;

  const AuthToggleTabs({
    super.key,
    required this.rightTitle,
    required this.leftTitle,
    required this.isRightSelected,
    required this.onRightTap,
    required this.onLeftTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onLeftTap,
              child: Container(
                decoration: BoxDecoration(
                  color: !isRightSelected
                      ? AppColors.primaryRed
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  leftTitle,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: !isRightSelected
                        ? AppColors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onRightTap,
              child: Container(
                decoration: BoxDecoration(
                  color:
                  isRightSelected ? AppColors.primaryRed : AppColors.white,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  rightTitle,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: isRightSelected
                        ? AppColors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
