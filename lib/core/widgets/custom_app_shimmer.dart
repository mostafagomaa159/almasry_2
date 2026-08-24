import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Wraps a skeleton layout in the app's shimmer sweep. Give it grey blocks
/// shaped like the content that is coming — it paints the animation, the
/// caller owns the shape.
class CustomAppShimmer extends StatelessWidget {
  final Widget child;

  const CustomAppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.borderSoft,
      highlightColor: AppColors.surfaceScaffold,
      child: child,
    );
  }
}

/// One opaque block of a skeleton. The colour is irrelevant to what is seen —
/// [CustomAppShimmer] paints its sweep over whatever is opaque — so this exists for
/// the shape, not the fill.
///
/// Only meaningful inside an [CustomAppShimmer].
class CustomAppShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;

  /// `0` gives square corners, for the full-bleed blocks.
  final double borderRadius;

  final Color color;

  const CustomAppShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.color = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius == 0
            ? null
            : BorderRadius.circular(borderRadius.r),
      ),
    );
  }
}

/// A grid of [CustomAppShimmerBox] tiles standing in for a grid that is still
/// loading. Give it the same geometry as the real grid so the content drops
/// straight into the layout it replaces.
///
/// Wrap it in an [CustomAppShimmer] — it does not animate on its own.
class CustomAppShimmerGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  /// `null` draws no border, which is what the borderless card grids want.
  final Color? borderColor;

  const CustomAppShimmerGrid({
    super.key,
    required this.itemCount,
    required this.crossAxisCount,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.childAspectRatio = 1,
    this.padding,
    this.borderRadius = 16,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing.w,
        mainAxisSpacing: mainAxisSpacing.h,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        if (borderColor == null) {
          return CustomAppShimmerBox(borderRadius: borderRadius);
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(borderRadius.r),
            border: Border.all(color: borderColor!),
          ),
        );
      },
    );
  }
}
