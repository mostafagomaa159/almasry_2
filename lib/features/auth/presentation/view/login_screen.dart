import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/focus_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../home/presentation/view/blink_home_screen.dart';
import '../view_model/auth_cubit.dart';
import '../view_model/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_toggle_tabs.dart';
import '../widgets/remember_me_row.dart';
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

  Widget _buildRegularLoginForm(AuthState state, AuthCubit authCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: emailOrPhoneController,
          focusNode: emailOrPhoneFocusNode,
          hintText: AppStrings.emailOrPhone,
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
          hintText: AppStrings.password,
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
          rememberMeTitle: AppStrings.rememberMe,
          forgotPasswordTitle: AppStrings.forgotPassword,
          onCheckboxTap: authCubit.toggleRememberMe,
          onForgotPasswordTap: () {},
        ),
        SizedBox(height: 34.h),
        AppButton(
          title: AppStrings.signIn,
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
          hintText: AppStrings.phoneNumber,
          errorText: state.emailOrPhoneError,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onChanged: (_) => _clearLoginErrors(),
          onEditingComplete: _submitPhoneLogin,
        ),
        SizedBox(height: 34.h),
        AppButton(
          title: AppStrings.sendVerificationCode,
          onPressed: _submitPhoneLogin,
          isLoading: state.isLoading,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final AuthCubit authCubit = context.read<AuthCubit>();

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding.w,
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(),
                    SizedBox(height: 18.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: AuthToggleTabs(
                        rightTitle: AppStrings.login,
                        leftTitle: AppStrings.loginWithPhone,
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
                      title: AppStrings.createAccount,
                      onPressed: _goToRegisterScreen,
                      isPrimary: false,
                    ),
                    SizedBox(height: 30.h),
                    Center(
                      child: GestureDetector(
                        onTap: _continueAsGuest,
                        child: Text(
                          AppStrings.continueAsGuest,
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
          ),
        );
      },
    );
  }
}
