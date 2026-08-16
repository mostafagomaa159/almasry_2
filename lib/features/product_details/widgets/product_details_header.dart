part of '../product_details_imports.dart';

/// The red-bordered screen header: back chevron, centred title and the doctor
/// avatar.
class ProductDetailsHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const ProductDetailsHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92.h,
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(
        start: 12.w,
        end: 20.w,
        top: 10.h,
        bottom: 14.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        border: Border.all(color: const Color(0xFFD7262E), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: Icon(
                AppDirection.back(),
                color: const Color(0xFF2C2C2C),
                size: 22.sp,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF202020),
                ),
              ),
            ),
          ),
          _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return SizedBox(
      width: 64.w,
      height: 64.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.asset(
          AppImages.profileDoctor,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.medical_services_outlined,
                color: const Color(0xFF11385B),
                size: 28.sp,
              ),
            );
          },
        ),
      ),
    );
  }
}
