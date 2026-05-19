part of '../auth_imports.dart';

class PasswordRules extends StatelessWidget {
  const PasswordRules({super.key});

  Widget _buildRuleItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Container(
            width: 8.w,
            height: 8.h,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRuleItem(LocaleKeys.passwordRuleUppercase.tr()),
          SizedBox(height: 6.h),
          _buildRuleItem(LocaleKeys.passwordRuleNumber.tr()),
          SizedBox(height: 6.h),
          _buildRuleItem(LocaleKeys.passwordRuleLength.tr()),
        ],
      ),
    );
  }
}
