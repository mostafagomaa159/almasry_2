import 'package:almasry_2/features/profile/view_model/profile_args.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:almasry_2/features/auth/auth.dart';
import 'package:almasry_2/core/core.dart';

import '../widgets/widgets.dart';

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

    if (!mounted) return;

    context.go(
      AppRoutes.home,
      extra: ProfileArgs(
        firstName: null,
        lastName: null,
        email: emailOrPhone.contains('@') ? emailOrPhone : null,
        phone: emailOrPhone.contains('@') ? null : emailOrPhone,
        source: 'login',
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

    if (!mounted) return;

    context.go(
      AppRoutes.home,
      extra: ProfileArgs(
        phone: phone,
        source: 'login',
      ),
    );
  }

  void _goToRegisterScreen() {
    FocusHelper.unfocusKeyboard(context);
    context.push(AppRoutes.signup);
  }

  void _continueAsGuest() {
    FocusHelper.unfocusKeyboard(context);
    context.go(
      AppRoutes.home,
      extra: const ProfileArgs(
        isGuest: true,
        source: 'guest',
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
                        8.verticalSpace,
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
                          RegularLoginForm(
                            state: state,
                            authCubit: authCubit,
                            emailOrPhoneController: emailOrPhoneController,
                            passwordController: passwordController,
                            emailOrPhoneFocusNode: emailOrPhoneFocusNode,
                            passwordFocusNode: passwordFocusNode,
                            onSubmit: _submitRegularLogin,
                            onClearErrors: _clearLoginErrors,
                          )
                        else
                          PhoneLoginForm(
                            state: state,
                            phoneController: phoneController,
                            phoneFocusNode: phoneFocusNode,
                            onSubmit: _submitPhoneLogin,
                            onClearErrors: _clearLoginErrors,
                          ),
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
              ],
            ),
          ),

        );
      },
    );
  }
}
