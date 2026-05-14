part of '../product_details_imports.dart';

class ProductDetailsHeader extends StatelessWidget {
  final String title;
  final bool isArabic;

  const ProductDetailsHeader({
    super.key,
    required this.title,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      color: const Color(0xFFF7F7F7),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            behavior: HitTestBehavior.opaque,
            child: Icon(
              isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
              color: const Color(0xFF2C2C2C),
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1D1D1D),
              ),
            ),
          ),
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.share_outlined,
              color: Colors.black,
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }
}
