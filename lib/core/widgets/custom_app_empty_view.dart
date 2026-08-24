import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shown when a request succeeded but returned nothing. [icon] and
/// [description] are optional — without them this is the plain centred line
/// most lists use.
class CustomAppEmptyView extends StatelessWidget {
  final String message;
  final IconData? icon;
  final String? description;

  const CustomAppEmptyView({
    super.key,
    required this.message,
    this.icon,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 70.sp, color: Colors.grey),
              16.verticalSpace,
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: icon == null ? 15.sp : 20.sp,
                fontWeight: icon == null ? FontWeight.w400 : FontWeight.w700,
                color: icon == null ? AppColors.textSecondary : Colors.black87,
              ),
            ),
            if (description != null) ...[
              8.verticalSpace,
              Text(
                description!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
