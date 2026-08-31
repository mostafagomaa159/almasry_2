part of '../otp_verification_imports.dart';

class OtpActionsSection extends StatelessWidget {
  final OtpViewModel vm;

  const OtpActionsSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        32.verticalSpace,
        BlocBuilder<GenericCubit<String>, GenericState<String>>(
          bloc: vm._otpTextCubit,
          builder: (context, otpState) {
            return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
              bloc: vm._otpLoadingCubit,
              builder: (context, blocState) {
                return CustomAppButton(
                  title: LocaleKeys.otpVerify.tr(),
                  isLoading: blocState.data,
                  isEnabled: vm._isVerifyEnabled(),
                  onPressed: () => vm._verifyOtp(context),
                  height: 54.h,
                  backgroundColor: vm._isVerifyEnabled()
                      ? AppColors.borderField
                      : AppColors.border,
                  borderColor: vm._isVerifyEnabled()
                      ? AppColors.borderField
                      : AppColors.border,
                  textColor: Colors.white,
                  borderRadius: 14,
                  fontSize: 22,
                );
              },
            );
          },
        ),
        36.verticalSpace,
        OtpResendSection(vm: vm),
      ],
    );
  }
}
