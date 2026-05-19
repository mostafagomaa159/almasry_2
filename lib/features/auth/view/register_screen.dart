part of '../auth_imports.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  late final FocusNode firstNameFocusNode;
  late final FocusNode lastNameFocusNode;
  late final FocusNode phoneFocusNode;
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    firstNameFocusNode = FocusNode();
    lastNameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();

    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    phoneFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void _clearRegisterErrors() {
    context.read<AuthCubit>().clearRegisterValidationErrors();
  }

  Future<void> _toggleLanguage() async {
    if (context.locale.languageCode == 'ar') {
      await context.setLocale(AppLocale.english);
    } else {
      await context.setLocale(AppLocale.arabic);
    }
  }

  Future<void> _submitRegister() async {
    FocusHelper.unfocusKeyboard(context);

    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String phone = phoneController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    final String? firstNameError = Validators.validateName(firstName);
    final String? lastNameError = Validators.validateName(lastName);
    final String? phoneError = Validators.validatePhone(phone);
    final String? emailError = Validators.validateEmail(email);
    final String? passwordError = Validators.validateStrongPassword(password);

    context.read<AuthCubit>().setRegisterValidationErrors(
      firstNameError: firstNameError,
      lastNameError: lastNameError,
      phoneError: phoneError,
      emailError: emailError,
      passwordError: passwordError,
    );

    if (firstNameError != null) {
      firstNameFocusNode.requestFocus();
      return;
    }

    if (lastNameError != null) {
      lastNameFocusNode.requestFocus();
      return;
    }

    if (phoneError != null) {
      phoneFocusNode.requestFocus();
      return;
    }

    if (emailError != null) {
      emailFocusNode.requestFocus();
      return;
    }

    if (passwordError != null) {
      passwordFocusNode.requestFocus();
      return;
    }

    await context.read<AuthCubit>().register();

    if (!mounted) return;

    context.go(
      AppRoutes.home,
      extra: ProfileArgs(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        source: 'signup',
      ),
    );
  }

  void _goToLogin() {
    FocusHelper.unfocusKeyboard(context);
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final AuthCubit authCubit = context.read<AuthCubit>();

        return Scaffold(
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                const AuthHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.screenHorizontalPadding.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LoginLanguageSwitch(
                          isArabic: isArabic,
                          onTap: _toggleLanguage,
                        ),
                        SizedBox(height: 8.h),
                        RegisterForm(
                          state: state,
                          authCubit: authCubit,
                          firstNameController: firstNameController,
                          lastNameController: lastNameController,
                          phoneController: phoneController,
                          emailController: emailController,
                          passwordController: passwordController,
                          firstNameFocusNode: firstNameFocusNode,
                          lastNameFocusNode: lastNameFocusNode,
                          phoneFocusNode: phoneFocusNode,
                          emailFocusNode: emailFocusNode,
                          passwordFocusNode: passwordFocusNode,
                          onSubmit: _submitRegister,
                          onClearErrors: _clearRegisterErrors,
                        ),
                        SizedBox(height: 28.h),
                        Center(
                          child: GestureDetector(
                            onTap: _goToLogin,
                            child: Text(
                              LocaleKeys.login.tr(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF173B63),
                                decoration: TextDecoration.underline,
                                decorationColor: const Color(0xFF173B63),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
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
