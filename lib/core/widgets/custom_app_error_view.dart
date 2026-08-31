import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CustomAppErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final EdgeInsets padding = EdgeInsets.symmetric(
          horizontal: 32.w,
          vertical: 24.h,
        );

        if (!constraints.maxHeight.isFinite) {
          return Padding(padding: padding, child: _content());
        }

        return SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - padding.vertical).clamp(
                0,
                double.infinity,
              ),
            ),
            child: _content(),
          ),
        );
      },
    );
  }

  Widget _content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.error_outline, size: 48.sp, color: AppColors.textSecondary),
        12.verticalSpace,
        Text(
          message.isNotEmpty ? message : LocaleKeys.somethingWentWrong.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.sp, color: AppColors.textSecondary),
        ),
        if (onRetry != null) ...<Widget>[
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
    );
  }
}
