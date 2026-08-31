part of '../login_imports.dart';

class LoginViewModel {
  final _authService = sl<AuthSessionService>();
  final _startupService = sl<AppStartupService>();
  final _navService = sl<NavigationService>();
  final _userProfileService = sl<UserProfileService>();

  late final TextEditingController _emailOrPhoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;

  late final FocusNode _emailOrPhoneFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _phoneFocusNode;

  final GenericCubit<bool> _isRegularLoginCubit = GenericCubit<bool>(true);

  late final GenericCubit<bool> _validationCubit = _authService.validationCubit;
  late final GenericCubit<bool> _loadingCubit = _authService.loadingCubit;
  late final GenericCubit<bool> _phoneAuthLoadingCubit =
      _authService.phoneAuthLoadingCubit;
  late final GenericCubit<bool> _passwordHiddenCubit =
      _authService.passwordHiddenCubit;
  late final GenericCubit<bool> _rememberMeCubit = _authService.rememberMeCubit;

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

  void _onTabChanged(BuildContext context, bool isRegularLoginSelected) {
    _isRegularLoginCubit.onUpdateData(isRegularLoginSelected);

    FocusHelper.unfocusKeyboard(context);
    _authService.clearLoginValidationErrors();
  }

  void _clearLoginErrors() {
    _authService.clearLoginValidationErrors();
  }

  void _togglePasswordVisibility() {
    _authService.togglePasswordVisibility();
  }

  void _toggleRememberMe() {
    _authService.toggleRememberMe();
  }

  void _focusPassword() {
    _passwordFocusNode.requestFocus();
  }

  Future<void> _submitRegularLogin(BuildContext context) async {
    FocusHelper.unfocusKeyboard(context);

    final String emailOrPhone = _emailOrPhoneController.text.trim();
    final String password = _passwordController.text;

    final String? emailOrPhoneError = Validators.validateEmailOrPhone(
      emailOrPhone,
    );
    final String? passwordError = Validators.validatePassword(password);

    _authService.setLoginValidationErrors(
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

    await _authService.login();

    await _startupService.saveLoggedIn();

    if (emailOrPhone.contains('@')) {
      await _userProfileService.save(email: emailOrPhone, phone: '');
    } else {
      await _userProfileService.save(phone: emailOrPhone, email: '');
    }

    if (!context.mounted) return;

    _navService.goNamed(RouteNames.home);
  }

  Future<void> _submitPhoneLogin(BuildContext context) async {
    FocusHelper.unfocusKeyboard(context);

    final String phone = _phoneController.text.trim();
    final String? phoneError = Validators.validatePhone(phone);

    _authService.setLoginValidationErrors(
      emailOrPhoneError: phoneError,
      passwordError: null,
    );

    if (phoneError != null) {
      _phoneFocusNode.requestFocus();
      return;
    }

    final bool success = await _authService.sendVerificationCode(phone);

    if (!context.mounted || !success) return;

    final String verificationPhone = _authService.verificationPhone ?? phone;

    _navService.pushNamed(
      RouteNames.otpVerification,
      extra: OtpVerificationArgs(phone: verificationPhone),
    );
  }

  void _goToRegisterScreen() {
    _navService.pushNamed(RouteNames.signup);
  }

  void _continueAsGuest(BuildContext context) {
    FocusHelper.unfocusKeyboard(context);
    _navService.goNamed(
      RouteNames.home,
      extra: const ProfileArgs(isGuest: true, source: 'guest'),
    );
  }
}
