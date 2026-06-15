part of '../auth_imports.dart';

class OtpVerificationArgs {
  final String phone;

  const OtpVerificationArgs({required this.phone});
}

class OtpVerificationView extends StatefulWidget {
  final OtpVerificationArgs args;

  const OtpVerificationView({super.key, required this.args});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  late final TextEditingController otpController;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  final AuthViewModel viewModel = sl<AuthViewModel>();

  String _maskPhone(String phone) {
    final cleaned = phone.replaceAll(' ', '');
    if (cleaned.length < 4) return phone;

    final start = cleaned.substring(0, 2);
    final end = cleaned.substring(cleaned.length - 2);
    return '$start${'_' * (cleaned.length - 4)}$end';
  }

  Future<void> _verifyOtp() async {
    FocusScope.of(context).unfocus();

    final otp = otpController.text.trim();

    final success = await viewModel.verifyOtpCode(otp);

    if (!mounted || !success) return;

    context.go(
      AppRoutes.home,
      extra: ProfileArgs(phone: widget.args.phone, source: 'otp_login'),
    );
  }

  Future<void> _resendCode() async {
    FocusScope.of(context).unfocus();

    final success = await viewModel.resendVerificationCode();

    if (!mounted || !success) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Verification code resent')));
  }

  @override
  Widget build(BuildContext context) {
    final maskedPhone = _maskPhone(widget.args.phone);

    return BlocBuilder<GenericCubit<UserModel>, GenericState<UserModel>>(
      builder: (context, state) {
        final data = state.data;

        final bool isVerifyEnabled =
            otpController.text.trim().length == 5 &&
            !data.isOtpVerificationLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                AuthHeader(
                  showBackButton: true,
                  onBackPressed: () => context.pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 36),
                        const Text(
                          "Let's confirm your number",
                          style: TextStyle(
                            fontSize: 31,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2A37),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'We have sent a verification code to your number.',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF6B7280),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          maskedPhone,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF1F2A37),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Pinput(
                          controller: otpController,
                          length: 5,
                          keyboardType: TextInputType.number,
                          forceErrorState:
                              data.otpError != null &&
                              data.otpError!.isNotEmpty,
                          onChanged: (_) => setState(() {}),
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
                              border: Border.all(
                                color: const Color(0xFFF1F1F1),
                              ),
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
                              border: Border.all(
                                color: const Color(0xFFD62828),
                              ),
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
                        if (data.otpError != null &&
                            data.otpError!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            data.otpError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        if (data.authErrorMessage != null &&
                            data.authErrorMessage!.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFECDD3),
                              ),
                            ),
                            child: Text(
                              data.authErrorMessage!,
                              style: const TextStyle(
                                color: Color(0xFFB42318),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        OtpVerifyButton(
                          isLoading: data.isOtpVerificationLoading,
                          isEnabled: isVerifyEnabled,
                          onPressed: _verifyOtp,
                        ),
                        const SizedBox(height: 36),
                        Center(
                          child: Text(
                            data.canResendOtp
                                ? 'Resend available now'
                                : 'Resend available yet ${data.otpCountdownSeconds} seconds',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: TextButton(
                            onPressed:
                                data.canResendOtp && !data.isPhoneAuthLoading
                                ? _resendCode
                                : null,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFD62828),
                            ),
                            child: data.isPhoneAuthLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Resend',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: data.canResendOtp
                                          ? const Color(0xFFD62828)
                                          : const Color(0xFFBDBDBD),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
