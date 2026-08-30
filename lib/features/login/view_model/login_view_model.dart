part of '../login_imports.dart';

class LoginViewModel {
  /// Services

  final AuthSessionService _auth = sl<AuthSessionService>();
  final AppStartupService _startup = sl<AppStartupService>();
  final NavigationService _nav = sl<NavigationService>();
  final SharedPrefsServices _prefs = sl<SharedPrefsServices>();

  /// Variables

  late final TextEditingController _emailOrPhoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;

  late final FocusNode _emailOrPhoneFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _phoneFocusNode;

  final GenericCubit<bool> _isRegularLoginCubit = GenericCubit<bool>(true);

  late final GenericCubit<UserModel> _authCubit = _auth.authCubit;

  UserModel _data() => _auth.authCubit.state.data;

  /// Init

  void _init() {
    _emailOrPhoneController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();

    _emailOrPhoneFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
  }

  void _dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();

    _emailOrPhoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();

    _isRegularLoginCubit.close();
  }

  /// Form state

  void _onTabChanged(BuildContext context, bool isRegularLoginSelected) {
    _isRegularLoginCubit.onUpdateData(isRegularLoginSelected);

    FocusHelper.unfocusKeyboard(context);
    _auth.clearLoginValidationErrors();
  }

  void _clearLoginErrors() {
    _auth.clearLoginValidationErrors();
  }

  void _togglePasswordVisibility() {
    _auth.togglePasswordVisibility();
  }

  void _toggleRememberMe() {
    _auth.toggleRememberMe();
  }

  void _focusPassword() {
    _passwordFocusNode.requestFocus();
  }

  /// Actions

  Future<void> _submitRegularLogin(BuildContext context) async {
    FocusHelper.unfocusKeyboard(context);

    final String emailOrPhone = _emailOrPhoneController.text.trim();
    final String password = _passwordController.text;

    final String? emailOrPhoneError = Validators.validateEmailOrPhone(
      emailOrPhone,
    );
    final String? passwordError = Validators.validatePassword(password);

    _auth.setLoginValidationErrors(
      emailOrPhoneError: emailOrPhoneError,
      passwordError: passwordError,
    );

    if (emailOrPhoneError != null) {
      _emailOrPhoneFocusNode.requestFocus();
      return;
    }

    if (passwordError != null) {
      _passwordFocusNode.requestFocus();
      return;
    }

    await _auth.login();
    await _startup.saveLoggedIn();
    await _prefs.setBool(PrefKeys.isLoggedIn, true);

    if (emailOrPhone.contains('@')) {
      await _prefs.setString(PrefKeys.email, emailOrPhone);
      await _prefs.remove(PrefKeys.phone);
    } else {
      await _prefs.setString(PrefKeys.phone, emailOrPhone);
      await _prefs.remove(PrefKeys.email);
    }

    if (!context.mounted) return;

    _nav.goNamed(RouteNames.home);
  }

  Future<void> _submitPhoneLogin(BuildContext context) async {
    FocusHelper.unfocusKeyboard(context);

    final String phone = _phoneController.text.trim();
    final String? phoneError = Validators.validatePhone(phone);

    _auth.setLoginValidationErrors(
      emailOrPhoneError: phoneError,
      passwordError: null,
    );

    if (phoneError != null) {
      _phoneFocusNode.requestFocus();
      return;
    }

    final bool success = await _auth.sendVerificationCode(phone);

    if (!context.mounted || !success) return;

    final verificationPhone = _data().verificationPhone ?? phone;

    _nav.pushNamed(
      RouteNames.otpVerification,
      extra: OtpVerificationArgs(phone: verificationPhone),
    );
  }

  void _goToRegisterScreen() {
    _nav.pushNamed(RouteNames.signup);
  }

  void _continueAsGuest(BuildContext context) {
    FocusHelper.unfocusKeyboard(context);
    _nav.goNamed(
      RouteNames.home,
      extra: const ProfileArgs(isGuest: true, source: 'guest'),
    );
  }
}
