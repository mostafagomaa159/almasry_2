import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onTap;

  final double size;
  final double iconSize;
  final Color backgroundColor;

  final Color? borderColor;

  final double borderRadius;
  final bool isCircle;

  final Color activeColor;
  final Color inactiveColor;

  final bool roundedOutline;

  final double? shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetY;

  const CustomAppFavoriteButton({
    super.key,
    required this.isFavorite,
    this.onTap,
    this.size = 32,
    this.iconSize = 18,
    this.backgroundColor = AppColors.white,
    this.borderColor = AppColors.borderLight,
    this.borderRadius = 10,
    this.isCircle = false,
    this.activeColor = AppColors.primaryRed,
    this.inactiveColor = AppColors.iconMuted,
    this.roundedOutline = true,
    this.shadowOpacity,
    this.shadowBlur = 6,
    this.shadowOffsetY = 2,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(
      isCircle ? size.w : borderRadius.r,
    );

    final IconData icon = isFavorite
        ? Icons.favorite
        : (roundedOutline
              ? Icons.favorite_border_rounded
              : Icons.favorite_border);

    Widget content = Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Icon(
        icon,
        size: iconSize.sp,
        color: isFavorite ? activeColor : inactiveColor,
      ),
    );

    if (onTap != null) {
      content = InkWell(onTap: onTap, borderRadius: radius, child: content);
    }

    Widget button = Material(
      color: backgroundColor,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    if (shadowOpacity != null) {
      button = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: shadowOpacity!),
              blurRadius: shadowBlur,
              offset: Offset(0, shadowOffsetY),
            ),
          ],
        ),
        child: button,
      );
    }

    return button;
  }
}
