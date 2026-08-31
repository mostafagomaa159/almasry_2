import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppPriceRow extends StatelessWidget {
  final String price;
  final String? oldPrice;

  final Axis axis;

  final TextStyle? priceStyle;

  final TextStyle? oldPriceStyle;

  final double spacing;
  final MainAxisAlignment mainAxisAlignment;

  final CrossAxisAlignment? crossAxisAlignment;

  const CustomAppPriceRow({
    super.key,
    required this.price,
    this.oldPrice,
    this.axis = Axis.horizontal,
    this.priceStyle,
    this.oldPriceStyle,
    this.spacing = 6,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle resolvedPriceStyle =
        priceStyle ??
        TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.titleNavy,
        );

    final TextStyle resolvedOldPriceStyle =
        (oldPriceStyle ??
                TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ))
            .copyWith(decoration: TextDecoration.lineThrough);

    final Widget current = Text(
      price,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: resolvedPriceStyle,
    );

    if (oldPrice == null) return current;

    final Widget previous = Text(
      oldPrice!,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: resolvedOldPriceStyle,
    );

    if (axis == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: [
          current,
          SizedBox(height: spacing.h),
          previous,
        ],
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        current,
        SizedBox(width: spacing.w),
        Flexible(child: previous),
      ],
    );
  }
}
