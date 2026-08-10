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
            return BlocBuilder<
              GenericCubit<UserModel>,
              GenericState<UserModel>
            >(
              bloc: vm._authCubit,
              builder: (context, blocState) {
                return AppButton(
                  title: LocaleKeys.otpVerify.tr(),
                  isLoading: blocState.data.isOtpVerificationLoading,
                  isEnabled: vm._isVerifyEnabled,
                  onPressed: () => vm._verifyOtp(context),
                  height: 54.h,
                  backgroundColor: vm._isVerifyEnabled
                      ? const Color(0xFFCFCFCF)
                      : const Color(0xFFD9D9D9),
                  borderColor: vm._isVerifyEnabled
                      ? const Color(0xFFCFCFCF)
                      : const Color(0xFFD9D9D9),
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
