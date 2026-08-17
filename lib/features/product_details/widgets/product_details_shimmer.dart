part of '../product_details_imports.dart';

/// The first-load skeleton — image block, summary lines, then the information
/// rows, laid out where the real sections land.
class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppShimmer(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 40.h),
        children: [
          CustomAppShimmerBox(height: 340.h, borderRadius: 0),

          12.verticalSpace,

          Container(
            color: AppColors.white,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppShimmerBox(width: 120.w, height: 16.h),
                12.verticalSpace,
                CustomAppShimmerBox(width: double.infinity, height: 16.h),
                8.verticalSpace,
                CustomAppShimmerBox(width: 220.w, height: 16.h),
                16.verticalSpace,
                CustomAppShimmerBox(width: 90.w, height: 26.h),
                14.verticalSpace,
                CustomAppShimmerBox(width: 140.w, height: 24.h),
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
                  child: CustomAppShimmerBox(
                    width: double.infinity,
                    height: 48.h,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
