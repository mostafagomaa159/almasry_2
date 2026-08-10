part of '../brands_imports.dart';

class BrandsErrorView extends StatelessWidget {
  final BrandsViewModel vm;
  final String message;

  const BrandsErrorView({
    super.key,
    required this.vm,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 12.h),
            Text(
              message.isNotEmpty
                  ? message
                  : LocaleKeys.somethingWentWrong.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: vm._retry,
              child: Text(
                LocaleKeys.retry.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
