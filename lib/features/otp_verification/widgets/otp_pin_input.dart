part of '../otp_verification_imports.dart';

class OtpPinInput extends StatelessWidget {
  final OtpViewModel vm;

  const OtpPinInput({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<UserModel>, GenericState<UserModel>>(
      bloc: vm._authCubit,
      builder: (context, blocState) => _buildInput(blocState.data),
    );
  }

  Widget _buildInput(UserModel state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Pinput(
          controller: vm._otpController,
          length: 5,
          keyboardType: TextInputType.number,
          forceErrorState: state.otpError != null && state.otpError!.isNotEmpty,
          onChanged: vm._onOtpChanged,
          defaultPinTheme: PinTheme(
            width: 58,
            height: 68,
            textStyle: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F1F1)),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 58,
            height: 68,
            textStyle: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD62828)),
            ),
          ),
          errorPinTheme: PinTheme(
            width: 58,
            height: 68,
            textStyle: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red),
            ),
          ),
        ),
        if (state.otpError != null && state.otpError!.isNotEmpty) ...[
          12.verticalSpace,
          Text(
            state.otpError!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (state.authErrorMessage != null &&
            state.authErrorMessage!.isNotEmpty) ...[
          14.verticalSpace,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFECDD3)),
            ),
            child: Text(
              state.authErrorMessage!,
              style: const TextStyle(color: Color(0xFFB42318), fontSize: 13),
            ),
          ),
        ],
      ],
    );
  }
}
