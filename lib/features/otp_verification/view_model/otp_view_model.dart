part of '../otp_verification_imports.dart';

class OtpViewModel {
  final _authService = sl<AuthSessionService>();
  final _navService = sl<NavigationService>();

  late final TextEditingController _otpController;

  String _phone = '';

  final GenericCubit<String> _otpTextCubit = GenericCubit<String>('');

  late final GenericCubit<bool> _validationCubit = _authService.validationCubit;
  late final GenericCubit<bool> _otpLoadingCubit = _authService.otpLoadingCubit;
  late final GenericCubit<bool> _phoneAuthLoadingCubit =
      _authService.phoneAuthLoadingCubit;
  late final GenericCubit<int> _otpCountdownCubit =
      _authService.otpCountdownCubit;

  String _maskedPhone() => _maskPhone(_phone);

  bool _isVerifyEnabled() =>
      _otpController.text.trim().length == 5 && !_otpLoadingCubit.state.data;

  void _init(String phone) {
    _phone = phone;
    _otpController = TextEditingController();
  }

  void _dispose() {
    _otpController.dispose();
    _otpTextCubit.close();
  }

  void _onOtpChanged(String value) {
    _otpTextCubit.onUpdateData(value);
  }

  String _maskPhone(String phone) {
    final cleaned = phone.replaceAll(' ', '');
    if (cleaned.length < 4) return phone;

    final start = cleaned.substring(0, 2);
    final end = cleaned.substring(cleaned.length - 2);
    return '$start${'_' * (cleaned.length - 4)}$end';
  }

  Future<void> _verifyOtp(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final otp = _otpController.text.trim();

    final success = await _authService.verifyOtpCode(otp);

    if (!context.mounted || !success) return;

    _navService.goNamed(
      RouteNames.home,
      extra: ProfileArgs(phone: _phone, source: 'otp_login'),
    );
  }

  Future<void> _resendCode(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final success = await _authService.resendVerificationCode();

    if (!context.mounted || !success) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(LocaleKeys.otpResentSuccess.tr())));
  }

  void _goBack() {
    _navService.pop();
  }
}
