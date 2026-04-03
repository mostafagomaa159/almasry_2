import 'package:almasry_2/core/constants/app_sizes.dart';
import 'package:almasry_2/core/localization/app_locale.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/utils/focus_helper.dart';
import 'package:almasry_2/core/utils/validators.dart';
import 'package:almasry_2/core/widgets/app_button.dart';
import 'package:almasry_2/core/widgets/app_text_field.dart';
import 'package:almasry_2/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:almasry_2/features/auth/presentation/view_model/auth_state.dart';
import 'package:almasry_2/features/auth/presentation/widgets/auth_header.dart';
import 'package:almasry_2/features/auth/presentation/widgets/auth_toggle_tabs.dart';
import 'package:almasry_2/features/auth/presentation/widgets/remember_me_row.dart';
import 'package:almasry_2/features/home/presentation/view/blink_home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailOrPhoneController;
  late final TextEditingController passwordController;
  late final TextEditingController phoneController;

  late final FocusNode emailOrPhoneFocusNode;
  late final FocusNode passwordFocusNode;
  late final FocusNode phoneFocusNode;

  bool isRegularLoginSelected = true;

  @override
  void initState() {
    super.initState();
    emailOrPhoneController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();

    emailOrPhoneFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    emailOrPhoneController.dispose();
    passwordController.dispose();
    phoneController.dispose();

    emailOrPhoneFocusNode.dispose();
    passwordFocusNode.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  void _onTabChanged(bool isLoginSelected) {
    setState(() {
      isRegularLoginSelected = isLoginSelected;
    });

    FocusHelper.unfocusKeyboard(context);
    context.read<AuthCubit>().clearLoginValidationErrors();
  }

  void _clearLoginErrors() {
    context.read<AuthCubit>().clearLoginValidationErrors();
  }

  Future<void> _submitRegularLogin() async {
    FocusHelper.unfocusKeyboard(context);

    final String emailOrPhone = emailOrPhoneController.text.trim();
    final String password = passwordController.text;

    final String? emailOrPhoneError =
    Validators.validateEmailOrPhone(emailOrPhone);
    final String? passwordError = Validators.validatePassword(password);

    context.read<AuthCubit>().setLoginValidationErrors(
      emailOrPhoneError: emailOrPhoneError,
      passwordError: passwordError,
    );

    if (emailOrPhoneError != null) {
      emailOrPhoneFocusNode.requestFocus();
      return;
    }

    if (passwordError != null) {
      passwordFocusNode.requestFocus();
      return;
    }

    await context.read<AuthCubit>().login();

    if (!mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BlinkHomeScreen(),
      ),
    );
  }

  Future<void> _submitPhoneLogin() async {
    FocusHelper.unfocusKeyboard(context);

    final String phone = phoneController.text.trim();
    final String? phoneError = Validators.validatePhone(phone);

    context.read<AuthCubit>().setLoginValidationErrors(
      emailOrPhoneError: phoneError,
      passwordError: null,
    );

    if (phoneError != null) {
      phoneFocusNode.requestFocus();
      return;
    }

    await context.read<AuthCubit>().sendVerificationCode();

    if (!mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BlinkHomeScreen(),
      ),
    );
  }

  void _goToRegisterScreen() {
    FocusHelper.unfocusKeyboard(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  void _continueAsGuest() {
    FocusHelper.unfocusKeyboard(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BlinkHomeScreen(),
      ),
    );
  }

  Future<void> _toggleLanguage() async {
    if (context.locale.languageCode == 'ar') {
      await context.setLocale(AppLocale.english);
    } else {
      await context.setLocale(AppLocale.arabic);
    }
  }

  Widget _buildRegularLoginForm(AuthState state, AuthCubit authCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: emailOrPhoneController,
          focusNode: emailOrPhoneFocusNode,
          hintText: LocaleKeys.emailOrPhone.tr(),
          errorText: state.emailOrPhoneError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (_) => _clearLoginErrors(),
          onEditingComplete: () {
            passwordFocusNode.requestFocus();
          },
        ),
        SizedBox(height: AppSizes.textFieldVerticalSpacing.h),
        AppTextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          hintText: LocaleKeys.password.tr(),
          errorText: state.passwordError,
          obscureText: state.isPasswordHidden,
          textInputAction: TextInputAction.done,
          onChanged: (_) => _clearLoginErrors(),
          onEditingComplete: _submitRegularLogin,
          suffixIcon: IconButton(
            onPressed: authCubit.togglePasswordVisibility,
            icon: Icon(
              state.isPasswordHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.black54,
              size: 24.sp,
            ),
          ),
        ),
        SizedBox(height: 22.h),
        RememberMeRow(
          isChecked: state.rememberMe,
          rememberMeTitle: LocaleKeys.rememberMe.tr(),
          forgotPasswordTitle: LocaleKeys.forgotPassword.tr(),
          onCheckboxTap: authCubit.toggleRememberMe,
          onForgotPasswordTap: () {},
        ),
        SizedBox(height: 34.h),
        AppButton(
          title: LocaleKeys.signIn.tr(),
          onPressed: _submitRegularLogin,
          isLoading: state.isLoading,
        ),
      ],
    );
  }

  Widget _buildPhoneLoginForm(AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: phoneController,
          focusNode: phoneFocusNode,
          hintText: LocaleKeys.phoneNumber.tr(),
          errorText: state.emailOrPhoneError,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onChanged: (_) => _clearLoginErrors(),
          onEditingComplete: _submitPhoneLogin,
        ),
        SizedBox(height: 60.h),
        AppButton(
          title: LocaleKeys.sendVerificationCode.tr(),
          onPressed: _submitPhoneLogin,
          isLoading: state.isLoading,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final AuthCubit authCubit = context.read<AuthCubit>();

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: _toggleLanguage,
                      child: Text(
                        isArabic ? 'EN' : 'AR',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: AuthToggleTabs(
                      rightTitle: LocaleKeys.login.tr(),
                      leftTitle: LocaleKeys.loginWithPhone.tr(),
                      isRightSelected: isRegularLoginSelected,
                      onRightTap: () => _onTabChanged(true),
                      onLeftTap: () => _onTabChanged(false),
                    ),
                  ),
                  SizedBox(height: 34.h),
                  if (isRegularLoginSelected)
                    _buildRegularLoginForm(state, authCubit)
                  else
                    _buildPhoneLoginForm(state),
                  SizedBox(height: 16.h),
                  AppButton(
                    title: LocaleKeys.createAccount.tr(),
                    onPressed: _goToRegisterScreen,
                    isPrimary: false,
                  ),
                  SizedBox(height: 30.h),
                  Center(
                    child: GestureDetector(
                      onTap: _continueAsGuest,
                      child: Text(
                        LocaleKeys.continueAsGuest.tr(),
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
