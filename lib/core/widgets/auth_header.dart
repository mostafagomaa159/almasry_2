import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/utils/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeader extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const AuthHeader({
    super.key,
    this.onBackPressed,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.h,
      child: Stack(
        children: [
          Positioned(
            top: -90.h,
            left: -130.w,
            child: Container(
              width: 320.w,
              height: 320.h,
              decoration: const BoxDecoration(
                color: AppColors.lightPink,
                shape: BoxShape.circle,
              ),
            ),
          ),
          if (showBackButton)
            Positioned(
              top: 56.h,
              left: 20.w,
              child: GestureDetector(
                onTap: onBackPressed,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 38.h),
              child: Image.asset(
                AppLogo.asset(context),
                width: 250.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
