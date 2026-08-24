import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The `− 1 +` pill on every product card.
///
/// The widget is stateless: it renders whatever [quantity] it is handed and
/// reports taps. Whether the counter lives in a `setState` or in a ViewModel
/// stays the caller's decision, which is why the three screens using it could
/// keep their different owners.
///
/// Pass a null [onDecrement] to grey the minus out — the disabled styling is
/// derived from the callback, never from the number.
class CustomAppQuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  /// Height of the outer pill.
  final double height;
  final double horizontalPadding;
  final double borderRadius;
  final Color borderColor;
  final Color? backgroundColor;

  /// Tap target of one +/- button, square.
  final double buttonSize;
  final double iconSize;

  /// Gap on each side of the number.
  final double spacing;

  final double fontSize;
  final double numberMinWidth;

  /// Colour of the number, and of an enabled +/- icon unless [iconColor]
  /// overrides it — the home card tints the two differently.
  final Color contentColor;
  final Color? iconColor;
  final Color disabledColor;

  /// Wraps each +/- in its own bordered square, the way the home card draws
  /// them. The other screens show bare icons.
  final bool boxedButtons;

  /// `true` puts the plus at the leading edge, `false` puts the minus there.
  /// The two orders are both in the design, so neither is a default worth
  /// forcing on the other.
  final bool incrementFirst;

  const CustomAppQuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.height = 36,
    this.horizontalPadding = 4,
    this.borderRadius = 12,
    this.borderColor = AppColors.border,
    this.backgroundColor,
    this.buttonSize = 26,
    this.iconSize = 17,
    this.spacing = 8,
    this.fontSize = 15,
    this.numberMinWidth = 12,
    this.contentColor = AppColors.titleNavy,
    this.iconColor,
    this.disabledColor = AppColors.disabledGrey,
    this.boxedButtons = false,
    this.incrementFirst = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget plus = _button(icon: Icons.add, onTap: onIncrement);
    final Widget minus = _button(icon: Icons.remove, onTap: onDecrement);
    final Widget gap = SizedBox(width: spacing.w);

    return Container(
      height: height.h,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: incrementFirst
            ? [plus, gap, _number(), gap, minus]
            : [minus, gap, _number(), gap, plus],
      ),
    );
  }

  Widget _number() {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: numberMinWidth.w),
      child: Center(
        child: Text(
          '$quantity',
          style: TextStyle(
            fontSize: fontSize.sp,
            fontWeight: FontWeight.w700,
            color: contentColor,
          ),
        ),
      ),
    );
  }

  Widget _button({required IconData icon, required VoidCallback? onTap}) {
    final bool isDisabled = onTap == null;

    final Widget glyph = Icon(
      icon,
      size: iconSize.sp,
      color: isDisabled ? disabledColor : (iconColor ?? contentColor),
    );

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: boxedButtons
            ? Container(
                width: buttonSize.w,
                height: buttonSize.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // Only the boxed variant needs these three, so they stay
                  // here rather than growing the constructor for one caller.
                  color: isDisabled ? AppColors.surfaceMuted : AppColors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isDisabled
                        ? AppColors.surfaceGrey
                        : AppColors.borderButton,
                  ),
                ),
                child: glyph,
              )
            : SizedBox(width: buttonSize.w, height: buttonSize.w, child: glyph),
      ),
    );
  }
}
