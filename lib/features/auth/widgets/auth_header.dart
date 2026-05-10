import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/utils/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260.h,
      child: Stack(
        children: [
          Positioned(
            top: -80.h,
            left: -120.w,
            child: Container(
              width: 320.w,
              height: 320.h,
              decoration: const BoxDecoration(
                color: AppColors.lightPink,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 30.h),
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
