part of '../otp_verification_imports.dart';

class OtpResendSection extends StatelessWidget {
  final OtpViewModel vm;

  const OtpResendSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<int>, GenericState<int>>(
      bloc: vm._otpCountdownCubit,
      builder: (context, countdownState) {
        final int seconds = countdownState.data;
        final bool canResendOtp = vm._authService.canResendOtp;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                canResendOtp
                    ? LocaleKeys.otpResendAvailableNow.tr()
                    : LocaleKeys.otpResendAvailableIn.tr(args: ['$seconds']),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSlateLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            8.verticalSpace,
            _ResendButton(vm: vm, canResendOtp: canResendOtp),
            24.verticalSpace,
          ],
        );
      },
    );
  }
}

class _ResendButton extends StatelessWidget {
  const _ResendButton({required this.vm, required this.canResendOtp});

  final OtpViewModel vm;
  final bool canResendOtp;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._phoneAuthLoadingCubit,
      builder: (context, state) {
        final bool isPhoneAuthLoading = state.data;

        return Center(
          child: TextButton(
            onPressed: canResendOtp && !isPhoneAuthLoading
                ? () => vm._resendCode(context)
                : null,
            style: TextButton.styleFrom(foregroundColor: AppColors.redOtp),
            child: isPhoneAuthLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    LocaleKeys.otpResend.tr(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: canResendOtp
                          ? AppColors.redOtp
                          : AppColors.unavailableGrey,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
