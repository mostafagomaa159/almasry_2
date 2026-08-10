import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RememberMeRow extends StatelessWidget {
  final bool isChecked;
  final String rememberMeTitle;
  final VoidCallback onCheckboxTap;

  const RememberMeRow({
    super.key,
    required this.isChecked,
    required this.rememberMeTitle,
    required this.onCheckboxTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          rememberMeTitle,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFFF1717),
          ),
        ),
        8.horizontalSpace,
        InkWell(
          onTap: onCheckboxTap,
          borderRadius: BorderRadius.circular(4.r),
          child: _RememberCheckbox(isChecked: isChecked),
        ),
      ],
    );
  }
}

class _RememberCheckbox extends StatelessWidget {
  final bool isChecked;

  const _RememberCheckbox({required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 22.w,
      height: 22.h,
      decoration: BoxDecoration(
        color: isChecked ? const Color(0xFFFF1717) : Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isChecked ? const Color(0xFFFF1717) : const Color(0xFFBDBDBD),
          width: 1.4,
        ),
      ),
      child: isChecked
          ? Icon(Icons.check, size: 15.sp, color: Colors.white)
          : null,
    );
  }
}
