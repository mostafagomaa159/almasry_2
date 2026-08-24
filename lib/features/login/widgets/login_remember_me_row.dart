import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/constants/app_durations.dart';

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
            color: AppColors.redLink,
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
      duration: AppDurations.highlight,
      width: 22.w,
      height: 22.h,
      decoration: BoxDecoration(
        color: isChecked ? AppColors.redLink : Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isChecked ? AppColors.redLink : AppColors.unavailableGrey,
          width: 1.4,
        ),
      ),
      child: isChecked
          ? Icon(Icons.check, size: 15.sp, color: Colors.white)
          : null,
    );
  }
}
