part of '../product_details_imports.dart';

/// The first-load skeleton — image block, summary lines, then the information
/// rows, laid out where the real sections land.
class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 40.h),
        children: [
          _Block(height: 340.h),

          12.verticalSpace,

          Container(
            color: AppColors.white,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Line(width: 120.w),
                12.verticalSpace,
                const _Line(width: double.infinity),
                8.verticalSpace,
                _Line(width: 220.w),
                16.verticalSpace,
                _Line(width: 90.w, height: 26.h),
                14.verticalSpace,
                _Line(width: 140.w, height: 24.h),
              ],
            ),
          ),

          10.verticalSpace,

          Container(
            color: AppColors.white,
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: List.generate(
                5,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _Line(width: double.infinity, height: 48.h),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(height: height, color: AppColors.white);
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.width, this.height});

  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 16.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}
