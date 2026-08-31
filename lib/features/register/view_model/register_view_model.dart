part of '../register_imports.dart';

class RegisterViewModel {
  final _authService = sl<AuthSessionService>();
  final _navService = sl<NavigationService>();
  final _startupService = sl<AppStartupService>();
  final _userProfileService = sl<UserProfileService>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _firstNameFocusNode;
  late final FocusNode _lastNameFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  late final GenericCubit<bool> _validationCubit = _authService.validationCubit;
  late final GenericCubit<bool> _loadingCubit = _authService.loadingCubit;
  late final GenericCubit<bool> _passwordHiddenCubit =
      _authService.passwordHiddenCubit;

  void _init() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  void _dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void _clearRegisterErrors() {
    _authService.clearRegisterValidationErrors();
  }

  void _togglePasswordVisibility() {
    _authService.togglePasswordVisibility();
  }

  void _focusLastName() {
    _lastNameFocusNode.requestFocus();
  }

  void _focusPhone() {
    _phoneFocusNode.requestFocus();
  }

  void _focusEmail() {
    _emailFocusNode.requestFocus();
  }

  void _focusPassword() {
    _passwordFocusNode.requestFocus();
  }

  Future<void> _toggleLanguage(BuildContext context) {
    return AppLocale.toggleLanguage(context);
  }

  Future<void> _submitRegister(BuildContext context) async {
    FocusHelper.unfocusKeyboard(context);

    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String phone = _phoneController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    final String? firstNameError = Validators.validateName(firstName);
    final String? lastNameError = Validators.validateName(lastName);
    final String? phoneError = Validators.validatePhone(phone);
    final String? emailError = Validators.validateEmail(email);
    final String? passwordError = Validators.validateStrongPassword(password);

    _authService.setRegisterValidationErrors(
      firstNameError: firstNameError,
      lastNameError: lastNameError,
      phoneError: phoneError,
      emailError: emailError,
      passwordError: passwordError,
    );

    if (firstNameError != null) {
      _firstNameFocusNode.requestFocus();
      return;
    }

    if (lastNameError != null) {
      _lastNameFocusNode.requestFocus();
      return;
    }

    if (phoneError != null) {
      _phoneFocusNode.requestFocus();
      return;
    }

    if (emailError != null) {
      _emailFocusNode.requestFocus();
      return;
    }

    if (passwordError != null) {
      _passwordFocusNode.requestFocus();
      return;
    }

    await _authService.register();

    await _userProfileService.save(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    );

    await _startupService.saveLoggedIn();

    if (!context.mounted) return;

    _navService.goNamed(
      RouteNames.home,
      extra: ProfileArgs(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        source: 'signup',
      ),
    );
  }

  void _goToLogin(BuildContext context) {
    FocusHelper.unfocusKeyboard(context);
    _navService.goNamed(RouteNames.login);
  }
}
