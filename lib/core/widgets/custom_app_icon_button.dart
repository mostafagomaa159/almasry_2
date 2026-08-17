import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/utils/app_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A fixed-size tappable square (or circle) holding one icon — the filled
/// buttons in the headers and over the product images.
///
/// Unlike Material's `IconButton` this has no invisible 48dp padding of its
/// own, so the size passed is the size drawn. That is why the layouts using it
/// could keep their spacing.
class CustomAppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;

  /// Ignored when [isCircle] is set.
  final double borderRadius;
  final bool isCircle;

  /// `null` draws no border.
  final Color? borderColor;

  const CustomAppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 48,
    this.iconSize = 22,
    this.backgroundColor = AppColors.white,
    this.iconColor = AppColors.textPrimary,
    this.borderRadius = 12,
    this.isCircle = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(
      isCircle ? size.w : borderRadius.r,
    );

    return Material(
      color: backgroundColor,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          width: size.w,
          height: size.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: borderColor == null
                ? null
                : Border.all(color: borderColor!),
          ),
          child: Icon(icon, size: iconSize.sp, color: iconColor),
        ),
      ),
    );
  }
}

/// The bare back chevron the inner screens put at the leading edge of their
/// header. Sized by padding rather than a box, so it lines up with the text
/// beside it instead of with a button grid.
///
/// The glyph comes from [AppDirection], which deliberately does not mirror with
/// the locale.
class CustomAppBackButton extends StatelessWidget {
  final VoidCallback onTap;
  final double iconSize;
  final Color color;
  final double padding;
  final IconData? icon;

  const CustomAppBackButton({
    super.key,
    required this.onTap,
    this.iconSize = 28,
    this.color = AppColors.textPrimary,
    this.padding = 6,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(padding.w),
          child: Icon(
            icon ?? AppDirection.chevronBack,
            size: iconSize.sp,
            color: color,
          ),
        ),
      ),
    );
  }
}
