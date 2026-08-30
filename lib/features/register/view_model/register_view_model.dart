part of '../register_imports.dart';

class RegisterViewModel {
  /// Services

  final AuthSessionService _auth = sl<AuthSessionService>();
  final NavigationService _nav = sl<NavigationService>();

  /// Variables

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

  late final GenericCubit<UserModel> _authCubit = _auth.authCubit;

  UserModel _data() => _auth.authCubit.state.data;

  /// Init

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

  /// Form state

  void _clearRegisterErrors() {
    _auth.clearRegisterValidationErrors();
  }

  void _togglePasswordVisibility() {
    _auth.togglePasswordVisibility();
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

  /// Actions

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

    _auth.setRegisterValidationErrors(
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

    await _auth.register();

    if (!context.mounted) return;

    _nav.goNamed(
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
    _nav.goNamed(RouteNames.login);
  }
}
