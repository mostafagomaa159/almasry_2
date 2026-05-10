import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/utils/app_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        border: Border.all(
          color: AppColors.primaryRed,
          width: 1,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryRed.withOpacity(0.5),
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/Red_Big_Card.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  LocaleKeys.homeTalkToDoctor.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(
              AppLogo.asset(context),
              width: 120.w,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 18.w),
            Icon(
              Icons.menu,
              size: 30.sp,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
