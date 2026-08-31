part of '../otp_verification_imports.dart';

class OtpPinInput extends StatelessWidget {
  final OtpViewModel vm;

  const OtpPinInput({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._validationCubit,
      builder: (context, blocState) => _buildInput(),
    );
  }

  Widget _buildInput() {
    final String? otpError = vm._authService.otpError;
    final String? authErrorMessage = vm._authService.authErrorMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Pinput(
          controller: vm._otpController,
          length: 5,
          keyboardType: TextInputType.number,
          forceErrorState: otpError != null && otpError.isNotEmpty,
          onChanged: vm._onOtpChanged,
          defaultPinTheme: PinTheme(
            width: 58,
            height: 68,
            textStyle: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.textSlate,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceField),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 58,
            height: 68,
            textStyle: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.textSlate,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.redOtp),
            ),
          ),
          errorPinTheme: PinTheme(
            width: 58,
            height: 68,
            textStyle: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.textSlate,
            ),
            decoration: BoxDecoration(
              color: AppColors.redTintLightest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red),
            ),
          ),
        ),
        if (otpError != null && otpError.isNotEmpty) ...[
          12.verticalSpace,
          Text(
            otpError,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (authErrorMessage != null && authErrorMessage.isNotEmpty) ...[
          14.verticalSpace,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.redTintPink,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.redTintBorder),
            ),
            child: Text(
              authErrorMessage,
              style: const TextStyle(color: AppColors.redError, fontSize: 13),
            ),
          ),
        ],
      ],
    );
  }
}
