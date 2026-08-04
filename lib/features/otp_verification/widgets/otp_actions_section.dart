part of '../otp_verification_imports.dart';

class OtpActionsSection extends StatelessWidget {
  final OtpViewModel vm;

  const OtpActionsSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        BlocBuilder<GenericCubit<String>, GenericState<String>>(
          bloc: vm._otpTextCubit,
          builder: (context, otpState) {
            return BlocBuilder<
              GenericCubit<UserModel>,
              GenericState<UserModel>
            >(
              bloc: vm._authCubit,
              builder: (context, blocState) {
                return OtpVerifyButton(
                  isLoading: blocState.data.isOtpVerificationLoading,
                  isEnabled: vm._isVerifyEnabled,
                  onPressed: () => vm._verifyOtp(context),
                );
              },
            );
          },
        ),
        const SizedBox(height: 36),
        OtpResendSection(vm: vm),
      ],
    );
  }
}
