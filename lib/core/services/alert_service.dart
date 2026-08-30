import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/widgets/custom_app_loading_view.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almasry_2/core/constants/app_durations.dart';

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
      animationDuration: AppDurations.alertSlide,
      animationReverseDuration: AppDurations.alertSlide,
      duration: AppDurations.alertVisible,
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
      animationDuration: AppDurations.alertSlide,
      animationReverseDuration: AppDurations.alertSlide,
      duration: AppDurations.alertVisible,
      borderRadius: 12.r,
      margin: EdgeInsets.all(5.r),
      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
    );
  }

  /// A notification that asks instead of telling. It carries its own two
  /// actions and waits — no timeout, because a prompt that vanished on its own
  /// would be answering for the user. Cancel closes it and reports nothing;
  /// only [onConfirm] reaches the caller.
  CancelFunc showConfirmation({
    required String title,
    required String confirmTitle,
    required String cancelTitle,
    required VoidCallback onConfirm,
  }) {
    return BotToast.showNotification(
      onlyOne: true,
      title: (_) => Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.darkBlue,
          fontSize: 15.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: (cancel) => Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: cancel,
              child: Text(
                cancelTitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            8.horizontalSpace,

            TextButton(
              onPressed: () {
                cancel();

                onConfirm();
              },
              child: Text(
                confirmTitle,
                style: TextStyle(
                  color: AppColors.primaryRed,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.white,
      backButtonBehavior: BackButtonBehavior.close,
      animationDuration: AppDurations.alertSlide,
      animationReverseDuration: AppDurations.alertSlide,
      duration: null,
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
        child: const CustomAppLoadingView(),
      );

    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
      status: progress ?? '',
    );
  }

  Widget showLoadingView() => const CustomAppLoadingView();

  void closeLoading() => EasyLoading.dismiss();
}
