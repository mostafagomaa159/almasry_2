import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/utils/app_direction.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almasry_2/core/constants/app_colors.dart';

/// A section title with the optional "more ›" affordance trailing it.
///
/// Started life inside the home feature; it is here because nothing about it is
/// home-specific and the categories and details screens want the same row.
class CustomAppSectionHeader extends StatelessWidget {
  final String title;

  /// Defaults to [LocaleKeys.homeMore].
  final String? actionTitle;

  final VoidCallback? onActionTap;
  final bool showAction;

  final double titleFontSize;
  final Color titleColor;
  final double actionFontSize;
  final Color actionColor;
  final EdgeInsetsGeometry? padding;

  const CustomAppSectionHeader({
    super.key,
    required this.title,
    this.actionTitle,
    this.onActionTap,
    this.showAction = true,
    this.titleFontSize = 22,
    this.titleColor = AppColors.navyHeading,
    this.actionFontSize = 14,
    this.actionColor = AppColors.textSectionAction,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final Widget titleWidget = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: titleFontSize.sp,
        fontWeight: FontWeight.w800,
        color: titleColor,
      ),
    );

    final Widget actionWidget = InkWell(
      onTap: onActionTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              actionTitle ?? LocaleKeys.homeMore.tr(),
              style: TextStyle(
                fontSize: actionFontSize.sp,
                fontWeight: FontWeight.w600,
                color: actionColor,
              ),
            ),
            Icon(AppDirection.chevronForward, size: 16.sp, color: actionColor),
          ],
        ),
      ),
    );

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: titleWidget),
          if (showAction) actionWidget,
        ],
      ),
    );
  }
}
