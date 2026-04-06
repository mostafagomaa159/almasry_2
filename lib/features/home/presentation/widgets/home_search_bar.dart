import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        textAlign: TextAlign.start,
        textDirection: Directionality.of(context),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: LocaleKeys.homeSearch.tr(),
          hintStyle: TextStyle(
            fontSize: 15.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 10.h,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}
