import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The white rounded panel behind almost every list row and grid tile.
///
/// It layers the three pieces each hand-rolled version was repeating:
/// * the shadow, painted *behind* the fill by a [DecoratedBox], so it never
///   tints the card's own surface the way a `boxShadow` on a colourless
///   `Container` does,
/// * the [Material] that owns the fill and clips the ink ripple to the radius,
/// * the bordered, padded box the content sits in.
///
/// A shadow is drawn only when [shadowOpacity] is set — the flat, bordered
/// cards leave it null.
class CustomAppCard extends StatelessWidget {
  final Widget child;

  /// Makes the whole card tappable, with the ripple clipped to [borderRadius].
  final VoidCallback? onTap;

  final Color color;

  /// `null` draws no border.
  final Color? borderColor;
  final double borderWidth;

  /// Logical radius — `.r` is applied here, so pass the design value.
  final double borderRadius;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  /// `null` draws no shadow.
  final double? shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetY;

  const CustomAppCard({
    super.key,
    required this.child,
    this.onTap,
    this.color = AppColors.white,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 16,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.shadowOpacity,
    this.shadowBlur = 14,
    this.shadowOffsetY = 4,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(borderRadius.r);

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: borderWidth),
      ),
      child: child,
    );

    if (onTap != null) {
      content = InkWell(onTap: onTap, borderRadius: radius, child: content);
    }

    Widget card = Material(
      color: color,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    if (shadowOpacity != null) {
      card = DecoratedBox(
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
        child: card,
      );
    }

    if (margin != null) return Padding(padding: margin!, child: card);

    return card;
  }
}
