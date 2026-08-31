part of '../cart_imports.dart';

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
        itemBuilder: (BuildContext context, int index) => const _ShimmerRow(),
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  const _ShimmerRow();

  static const Color _block = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 96.w,
          height: 96.w,
          decoration: BoxDecoration(
            color: _block,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),

        12.horizontalSpace,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _bar(width: 200.w, height: 16.h),
              10.verticalSpace,
              _bar(width: 110.w, height: 14.h),
              8.verticalSpace,
              _bar(width: 90.w, height: 14.h),
            ],
          ),
        ),

        8.horizontalSpace,

        _bar(width: 128.w, height: 44.w),
      ],
    );
  }

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _block,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}
