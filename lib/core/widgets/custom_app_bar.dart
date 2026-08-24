import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/constants/app_images.dart';
import 'package:almasry_2/core/utils/app_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The red-bordered header used by the inner screens (Brands, Contact us):
/// back chevron, centred title, and the doctor avatar overlapping the bottom
/// trailing corner — the same shape as the home header.
///
/// [onMenu] swaps the back chevron for a drawer hamburger, which is what the
/// tab-level screens (Cart) need: they have nothing to pop back to.
class CustomAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onMenu;

  const CustomAppBar({super.key, required this.title, this.onBack, this.onMenu})
    : assert(
        onBack != null || onMenu != null,
        'CustomAppBar needs a leading action: pass onBack or onMenu.',
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 105.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28.r),
                bottomRight: Radius.circular(28.r),
              ),
              border: Border.all(color: AppColors.primaryRed, width: 1.2),
            ),
            child: SafeArea(
              bottom: false,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: 0,
                    top: 10.h,
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: onMenu ?? onBack,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Padding(
                          padding: EdgeInsets.all(6.w),
                          child: Icon(
                            onMenu != null
                                ? Icons.menu
                                : AppDirection.chevronBack,
                            size: 28.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          PositionedDirectional(
            end: 2.w,
            bottom: 0,
            child: Container(
              width: 74.w,
              height: 74.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: ClipOval(
                  child: Image.asset(
                    AppImages.profileDoctor,
                    fit: BoxFit.cover,
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
