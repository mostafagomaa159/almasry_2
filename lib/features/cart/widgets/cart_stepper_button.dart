part of '../cart_imports.dart';

class _CartStepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CartStepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isEnabled ? AppColors.titleNavy : AppColors.borderField,
            width: 1.4,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 22.sp,
          color: isEnabled ? AppColors.titleNavy : AppColors.borderField,
        ),
      ),
    );
  }
}
