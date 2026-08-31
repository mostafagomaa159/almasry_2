import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

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

class CustomAppShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;

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

class CustomAppShimmerGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

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
