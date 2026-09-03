part of '../checkout_imports.dart';

class _CartRemoveBackground extends StatelessWidget {
  const _CartRemoveBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.delete_outline, color: AppColors.white, size: 26.sp),
          Icon(Icons.delete_outline, color: AppColors.white, size: 26.sp),
        ],
      ),
    );
  }
}
