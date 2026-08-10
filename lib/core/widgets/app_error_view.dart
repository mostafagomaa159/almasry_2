import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shown when a screen's request fails. Omit [onRetry] for the cases that only
/// report the message.
class AppErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: AppColors.textSecondary,
            ),
            12.verticalSpace,
            Text(
              message.isNotEmpty ? message : LocaleKeys.somethingWentWrong.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.sp, color: AppColors.textSecondary),
            ),
            if (onRetry != null) ...[
              16.verticalSpace,
              TextButton(
                onPressed: onRetry,
                child: Text(
                  LocaleKeys.retry.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
