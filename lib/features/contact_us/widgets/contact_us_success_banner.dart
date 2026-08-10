part of '../contact_us_imports.dart';

class ContactUsSuccessBanner extends StatelessWidget {
  final VoidCallback onClose;

  const ContactUsSuccessBanner({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF34A853),
            ),
            child: Icon(Icons.check, size: 22.sp, color: AppColors.white),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              LocaleKeys.contactUsSuccess.tr(),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          InkWell(
            onTap: onClose,
            child: Icon(
              Icons.close,
              size: 22.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
