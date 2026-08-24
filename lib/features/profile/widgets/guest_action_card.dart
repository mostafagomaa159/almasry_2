part of '../profile_imports.dart';

class GuestActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const GuestActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppCard(
      onTap: onTap,
      height: 135.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 18.h),
      borderColor: AppColors.borderSoft,
      shadowOpacity: 0.03,
      shadowBlur: 8,
      shadowOffsetY: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 38.sp, color: AppColors.iconGuestCard),
          16.verticalSpace,
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textIron,
            ),
          ),
        ],
      ),
    );
  }
}
