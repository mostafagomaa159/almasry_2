import 'package:almasry_2/core/utils/app_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almasry_2/core/constants/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 66.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: Row(
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.textCaption,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                AppDirection.forward(),
                color: AppColors.textCaption,
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
