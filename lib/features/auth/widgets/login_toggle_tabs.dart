import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthToggleTabs extends StatelessWidget {
  final String rightTitle;
  final String leftTitle;
  final bool isRightSelected;
  final VoidCallback onRightTap;
  final VoidCallback onLeftTap;

  const AuthToggleTabs({
    super.key,
    required this.rightTitle,
    required this.leftTitle,
    required this.isRightSelected,
    required this.onRightTap,
    required this.onLeftTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    final Widget rightTab = Expanded(
      child: _ToggleTabItem(
        title: rightTitle,
        isSelected: isRightSelected,
        onTap: onRightTap,
      ),
    );

    final Widget leftTab = Expanded(
      child: _ToggleTabItem(
        title: leftTitle,
        isSelected: !isRightSelected,
        onTap: onLeftTap,
      ),
    );

    return Container(
      height: 56.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        children: isRtl ? [rightTab, leftTab] : [leftTab, rightTab],
      ),
    );
  }
}

class _ToggleTabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleTabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFFFF1717) : Colors.white,
      borderRadius: BorderRadius.circular(28.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28.r),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: isSelected
                ? []
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF5E5E5E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
