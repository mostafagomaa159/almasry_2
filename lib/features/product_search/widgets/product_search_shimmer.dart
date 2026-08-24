part of '../product_search_imports.dart';

/// The grid's skeleton — same two-column geometry and card aspect ratio as
/// `_ProductSearchGrid`, so results drop straight into the layout they replace.
class ProductSearchShimmer extends StatelessWidget {
  const ProductSearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppShimmer(
      child: CustomAppShimmerGrid(
        itemCount: 6,
        crossAxisCount: 2,
        childAspectRatio: 0.56,
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      ),
    );
  }
}
