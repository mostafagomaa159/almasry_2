part of '../brands_imports.dart';

/// The grid's skeleton — same tile shape and spacing as `_BrandsGrid`, so the
/// real brands drop straight into the layout they replace.
class BrandsShimmer extends StatelessWidget {
  const BrandsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppShimmer(
      child: CustomAppShimmerGrid(
        itemCount: 12,
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        padding: EdgeInsets.all(20.r),
        borderRadius: 14,
        borderColor: AppColors.borderLight,
      ),
    );
  }
}
