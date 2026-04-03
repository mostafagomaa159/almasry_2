import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RememberMeRow extends StatelessWidget {
  final bool isChecked;
  final String rememberMeTitle;
  final String forgotPasswordTitle;
  final VoidCallback onCheckboxTap;
  final VoidCallback onForgotPasswordTap;

  const RememberMeRow({
    super.key,
    required this.isChecked,
    required this.rememberMeTitle,
    required this.forgotPasswordTitle,
    required this.onCheckboxTap,
    required this.onForgotPasswordTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    final Widget rememberSection = InkWell(
      onTap: onCheckboxTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RememberCheckbox(isChecked: isChecked),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                rememberMeTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final Widget forgotPasswordSection = GestureDetector(
      onTap: onForgotPasswordTap,
      child: Text(
        forgotPasswordTitle,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF333333),
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: isRtl
          ? [
        forgotPasswordSection,
        const Spacer(),
        Flexible(child: rememberSection),
      ]
          : [
        Flexible(child: rememberSection),
        const Spacer(),
        forgotPasswordSection,
      ],
    );
  }
}

class _RememberCheckbox extends StatelessWidget {
  final bool isChecked;

  const _RememberCheckbox({
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 20.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: isChecked ? const Color(0xFFD92525) : Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isChecked ? const Color(0xFFD92525) : const Color(0xFFBDBDBD),
          width: 1.4,
        ),
      ),
      child: isChecked
          ? Icon(
        Icons.check,
        size: 14.sp,
        color: Colors.white,
      )
          : null,
    );
  }
}
