part of '../cart_imports.dart';

class _CartShimmerRow extends StatelessWidget {
  const _CartShimmerRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 96.w,
          height: 96.w,
          decoration: BoxDecoration(
            color: AppColors.borderSoft,
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
        color: AppColors.borderSoft,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}
