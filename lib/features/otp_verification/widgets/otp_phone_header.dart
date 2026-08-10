part of '../otp_verification_imports.dart';

class OtpPhoneHeader extends StatelessWidget {
  final OtpViewModel vm;

  const OtpPhoneHeader({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        36.verticalSpace,
        Text(
          LocaleKeys.otpConfirmTitle.tr(),
          style: const TextStyle(
            fontSize: 31,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2A37),
          ),
        ),
        10.verticalSpace,
        Text(
          LocaleKeys.otpConfirmSubtitle.tr(),
          style: const TextStyle(
            fontSize: 17,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        4.verticalSpace,
        Text(
          vm._maskedPhone,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF1F2A37),
            fontWeight: FontWeight.w500,
          ),
        ),
        36.verticalSpace,
      ],
    );
  }
}
