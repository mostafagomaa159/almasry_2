import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const ProfileHeader({
    super.key,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 44.h,
          width: double.infinity,
          color: const Color(0xFFFF2D2D),
        ),
        Container(
          height: 72.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFFFF2D2D),
              width: 1.2,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28.r),
              bottomRight: Radius.circular(28.r),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 18.w,
                top: 12.h,
                child: Image.asset(
                  'assets/images/profile_left_icon.png',
                  width: 45.w,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 4.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 62.w,
                    height: 62.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFFF2D2D),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile_doctor.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 18.w,
                top: 22.h,
                child: GestureDetector(
                  onTap: onBackTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocaleKeys.back.tr(),
                        style: TextStyle(
                          color: const Color(0xFF7A7A7A),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: const Color(0xFF7A7A7A),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
