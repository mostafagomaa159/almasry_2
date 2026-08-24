import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shown when a screen's request fails. Omit [onRetry] for the cases that only
/// report the message.
///
/// Server copy is not length-checked at the call site, and a long message used
/// to overflow the body it was handed — so this scrolls when it has to.
///
/// It only adds a scroll view when it was given a bounded height. Some callers
/// (`_ProductDetailsPlaceholder`, `_ProductSearchPlaceholder`) already wrap it
/// in one so pull-to-refresh has something to pull on; nesting a second
/// scrollable inside that unbounded space would throw.
class AppErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorView({super.key, required this.message, this.onRetry});

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

  /// `min` with `center` centres inside whatever minimum height the parent
  /// imposes — the scroll branch's [ConstrainedBox], or the viewport-height
  /// floor the placeholder wrappers set — and hugs its content when there is
  /// none.
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
