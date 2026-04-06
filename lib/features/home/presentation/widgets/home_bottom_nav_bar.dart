import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/utils/app_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildItem(
            context: context,
            icon: Icons.person_outline,
            label: LocaleKeys.profile.tr(),
            index: 0,
          ),
          _buildItem(
            context: context,
            icon: Icons.shopping_cart_outlined,
            label: LocaleKeys.cart.tr(),
            index: 1,
            showBadge: true,
          ),
          _buildItem(
            context: context,
            icon: Icons.search,
            label: LocaleKeys.categories.tr(),
            index: 2,
          ),
          Expanded(
            child: InkWell(
              onTap: () => onTap(3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppLogo.asset(context),
                    width: 40.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    LocaleKeys.homePharmacy.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: selectedIndex == 3
                          ? AppColors.primaryRed
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    bool showBadge = false,
  }) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24.sp,
                  color: isSelected
                      ? AppColors.primaryRed
                      : AppColors.textSecondary,
                ),
                SizedBox(height: 4.h),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isSelected
                        ? AppColors.primaryRed
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (showBadge)
              Positioned(
                top: 12.h,
                right: 24.w,
                child: Container(
                  width: 16.w,
                  height: 16.h,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '10',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
