part of '../otp_verification_imports.dart';

class OtpResendSection extends StatelessWidget {
  final OtpViewModel vm;

  const OtpResendSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<UserModel>, GenericState<UserModel>>(
      bloc: vm._authCubit,
      builder: (context, blocState) {
        final UserModel state = blocState.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                state.canResendOtp
                    ? LocaleKeys.otpResendAvailableNow.tr()
                    : LocaleKeys.otpResendAvailableIn.tr(
                        args: ['${state.otpCountdownSeconds}'],
                      ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSlateLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            8.verticalSpace,
            Center(
              child: TextButton(
                onPressed: state.canResendOtp && !state.isPhoneAuthLoading
                    ? () => vm._resendCode(context)
                    : null,
                style: TextButton.styleFrom(foregroundColor: AppColors.redOtp),
                child: state.isPhoneAuthLoading
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
                          color: state.canResendOtp
                              ? AppColors.redOtp
                              : AppColors.unavailableGrey,
                        ),
                      ),
              ),
            ),
            24.verticalSpace,
          ],
        );
      },
    );
  }
}
