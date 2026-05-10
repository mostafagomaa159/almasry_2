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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isRtl ? 0 : 14.r),
          bottomLeft: Radius.circular(isRtl ? 0 : 14.r),
          topRight: Radius.circular(isRtl ? 14.r : 0),
          bottomRight: Radius.circular(isRtl ? 14.r : 0),
        ),
      ),
    );

    final Widget leftTab = Expanded(
      child: _ToggleTabItem(
        title: leftTitle,
        isSelected: !isRightSelected,
        onTap: onLeftTap,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isRtl ? 14.r : 0),
          bottomLeft: Radius.circular(isRtl ? 14.r : 0),
          topRight: Radius.circular(isRtl ? 0 : 14.r),
          bottomRight: Radius.circular(isRtl ? 0 : 14.r),
        ),
      ),
    );

    return Container(
      height: 58.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(16.r),
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
  final BorderRadius borderRadius;

  const _ToggleTabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFFD92525) : Colors.white,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF202020),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
