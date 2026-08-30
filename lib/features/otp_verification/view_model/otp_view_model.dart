part of '../otp_verification_imports.dart';

class OtpViewModel {
  /// Services

  final AuthSessionService _auth = sl<AuthSessionService>();
  final NavigationService _nav = sl<NavigationService>();

  /// Variables

  late final TextEditingController _otpController;

  String _phone = '';

  final GenericCubit<String> _otpTextCubit = GenericCubit<String>('');

  late final GenericCubit<UserModel> _authCubit = _auth.authCubit;

  UserModel _data() => _auth.authCubit.state.data;

  String _maskedPhone() => _maskPhone(_phone);

  bool _isVerifyEnabled() =>
      _otpController.text.trim().length == 5 &&
      !_data().isOtpVerificationLoading;

  /// Init

  void _init(String phone) {
    _phone = phone;
    _otpController = TextEditingController();
  }

  void _dispose() {
    _otpController.dispose();
    _otpTextCubit.close();
  }

  /// Form state

  void _onOtpChanged(String value) {
    _otpTextCubit.onUpdateData(value);
  }

  /// Helpers

  String _maskPhone(String phone) {
    final cleaned = phone.replaceAll(' ', '');
    if (cleaned.length < 4) return phone;

    final start = cleaned.substring(0, 2);
    final end = cleaned.substring(cleaned.length - 2);
    return '$start${'_' * (cleaned.length - 4)}$end';
  }

  /// Actions

  Future<void> _verifyOtp(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final otp = _otpController.text.trim();

    final success = await _auth.verifyOtpCode(otp);

    if (!context.mounted || !success) return;

    _nav.goNamed(
      RouteNames.home,
      extra: ProfileArgs(phone: _phone, source: 'otp_login'),
    );
  }

  Future<void> _resendCode(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final success = await _auth.resendVerificationCode();

    if (!context.mounted || !success) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(LocaleKeys.otpResentSuccess.tr())));
  }

  void _goBack() {
    _nav.pop();
  }
}
