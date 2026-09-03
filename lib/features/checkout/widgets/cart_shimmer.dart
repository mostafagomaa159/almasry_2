part of '../checkout_imports.dart';

class CartShimmer extends StatelessWidget {
  const CartShimmer({super.key});

  static const int _rowCount = 3;

  @override
  Widget build(BuildContext context) {
    return CustomAppShimmer(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _rowCount,
        separatorBuilder: (BuildContext context, int index) => 12.verticalSpace,
        itemBuilder: (BuildContext context, int index) =>
            const _CartShimmerRow(),
      ),
    );
  }
}
