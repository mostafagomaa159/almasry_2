part of '../otp_verification_imports.dart';

class OtpVerificationView extends StatefulWidget {
  final OtpVerificationArgs args;

  const OtpVerificationView({super.key, required this.args});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final OtpViewModel vm = OtpViewModel();

  @override
  void initState() {
    super.initState();
    vm._init(widget.args.phone);
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AuthHeader(showBackButton: true, onBackPressed: vm._goBack),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OtpPhoneHeader(vm: vm),
                    OtpPinInput(vm: vm),
                    OtpActionsSection(vm: vm),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
