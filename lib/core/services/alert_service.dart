import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/widgets/app_loading_view.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App-wide toasts and blocking loaders, so no feature has to build its own
/// SnackBar or spin up a dialog just to say "saved" or "something went wrong".
///
/// Registered in the locator — reach it with `sl<AlertService>()`. It needs no
/// [BuildContext], so ViewModels can call it directly.
///
/// Text alignment is intentionally [TextAlign.start]: the toasts render inside
/// `MaterialApp`, so the ambient `Directionality` already flips them for
/// Arabic.
class AlertService {
  CancelFunc showFCMAlert({
    required String title,
    required String subTitle,
    VoidCallback? onTap,
  }) {
    return BotToast.showNotification(
      onTap: onTap,
      title: (cancel) => Row(
        children: [
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          GestureDetector(
            onTap: cancel,
            child: Icon(Icons.clear, color: AppColors.textPrimary, size: 20.r),
          ),
        ],
      ),
      subtitle: (_) => Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: Text(
          subTitle,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.84),
      backButtonBehavior: BackButtonBehavior.close,
      animationDuration: const Duration(milliseconds: 500),
      animationReverseDuration: const Duration(milliseconds: 500),
      duration: const Duration(seconds: 4),
      borderRadius: 12.r,
      contentPadding: EdgeInsets.all(16.r),
    );
  }

  CancelFunc showAlert({required String title, bool isSuccess = false}) {
    return BotToast.showNotification(
      trailing: (cancel) => GestureDetector(
        onTap: cancel,
        child: Icon(Icons.clear, color: AppColors.textPrimary, size: 20.r),
      ),
      title: (_) => Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 12.sp),
      ),
      leading: (_) => Icon(
        isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
        color: isSuccess ? Colors.green : AppColors.primaryRed,
        size: 35.r,
      ),
      backgroundColor: AppColors.white,
      backButtonBehavior: BackButtonBehavior.close,
      animationDuration: const Duration(milliseconds: 500),
      animationReverseDuration: const Duration(milliseconds: 500),
      duration: const Duration(seconds: 4),
      borderRadius: 12.r,
      margin: EdgeInsets.all(5.r),
      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
    );
  }

  CancelFunc showSuccess(String title) =>
      showAlert(title: title, isSuccess: true);

  CancelFunc showError(String title) =>
      showAlert(title: title, isSuccess: false);

  void showLoadingDialog({String? progress}) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.light
      ..maskType = EasyLoadingMaskType.black
      ..animationStyle = EasyLoadingAnimationStyle.offset
      ..indicatorWidget = SizedBox(
        height: 40.h,
        width: 40.w,
        child: const AppLoadingView(),
      );

    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
      status: progress ?? '',
    );
  }

  Widget showLoadingView() => const AppLoadingView();

  void closeLoading() => EasyLoading.dismiss();
}
