import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileGuestHeader extends StatelessWidget {
  const ProfileGuestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFD72626),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: statusBarHeight,
            width: double.infinity,
            color: const Color(0xFFD72626),
          ),
          Container(
            height: 110.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFD72626),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.menu,
                    size: 28.sp,
                    color: const Color(0xFF5A4A4A),
                  ),
                ),
                Center(
                  child: Text(
                    LocaleKeys.profile.tr(),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: -18.h,
                  child: CircleAvatar(
                    radius: 42.r,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile_doctor.png',
                        width: 84.w,
                        height: 84.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
