part of '../order_details_imports.dart';

class OrderDetailsReorderButton extends StatelessWidget {
  final VoidCallback onTap;

  const OrderDetailsReorderButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 246.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: const Color(0xFFFF1717),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          LocaleKeys.reorder.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
