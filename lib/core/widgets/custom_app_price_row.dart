import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The current price with the pre-discount one struck through beside or below
/// it.
///
/// Both strings arrive pre-formatted — currency symbol, decimals and locale are
/// the caller's business, because the four screens using this build them from
/// different models.
///
/// [oldPrice] is drawn whenever it is non-null, *including* when it is empty:
/// the wishlist stores an empty string for "no old price" and still reserves
/// the line. Pass null to collapse it instead.
class CustomAppPriceRow extends StatelessWidget {
  final String price;
  final String? oldPrice;

  /// [Axis.horizontal] puts the old price beside the current one and lets it
  /// ellipsize; [Axis.vertical] stacks them.
  final Axis axis;

  final TextStyle? priceStyle;

  /// `TextDecoration.lineThrough` is applied on top of whatever is passed, so
  /// an override never has to remember it.
  final TextStyle? oldPriceStyle;

  final double spacing;
  final MainAxisAlignment mainAxisAlignment;

  /// Defaults per axis: centred across a row, leading-aligned down a column.
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

    // Deliberately not `MainAxisSize.min`: the home card centres this row
    // inside a full-width padding, which only works while the row fills it.
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
