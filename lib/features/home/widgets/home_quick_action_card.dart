part of '../home_imports.dart';

class HomeQuickActionCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const HomeQuickActionCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
            ),
            10.horizontalSpace,
            Image.asset(
              iconPath,
              width: 40.w,
              height: 40.h,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
