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
import 'package:almasry_2/features/home/presentation/view/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'login_screen.dart';

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

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  void _goToLogin() {
    FocusHelper.unfocusKeyboard(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  Widget _buildPasswordRules() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRuleItem(LocaleKeys.passwordRuleUppercase.tr()),
          SizedBox(height: 6.h),
          _buildRuleItem(LocaleKeys.passwordRuleNumber.tr()),
          SizedBox(height: 6.h),
          _buildRuleItem(LocaleKeys.passwordRuleLength.tr()),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Container(
            width: 8.w,
            height: 8.h,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
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
                  AppTextField(
                    controller: firstNameController,
                    focusNode: firstNameFocusNode,
                    hintText: LocaleKeys.firstName.tr(),
                    errorText: state.firstNameError,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _clearRegisterErrors(),
                    onEditingComplete: () {
                      lastNameFocusNode.requestFocus();
                    },
                  ),
                  SizedBox(height: 18.h),
                  AppTextField(
                    controller: lastNameController,
                    focusNode: lastNameFocusNode,
                    hintText: LocaleKeys.lastName.tr(),
                    errorText: state.lastNameError,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _clearRegisterErrors(),
                    onEditingComplete: () {
                      phoneFocusNode.requestFocus();
                    },
                  ),
                  SizedBox(height: 18.h),
                  AppTextField(
                    controller: phoneController,
                    focusNode: phoneFocusNode,
                    hintText: LocaleKeys.phoneNumber.tr(),
                    errorText: state.phoneError,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _clearRegisterErrors(),
                    onEditingComplete: () {
                      emailFocusNode.requestFocus();
                    },
                  ),
                  SizedBox(height: 18.h),
                  AppTextField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    hintText: LocaleKeys.email.tr(),
                    errorText: state.emailError,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _clearRegisterErrors(),
                    onEditingComplete: () {
                      passwordFocusNode.requestFocus();
                    },
                  ),
                  SizedBox(height: 18.h),
                  AppTextField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    hintText: LocaleKeys.password.tr(),
                    errorText: state.passwordError,
                    obscureText: state.isPasswordHidden,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => _clearRegisterErrors(),
                    onEditingComplete: _submitRegister,
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
                  _buildPasswordRules(),
                  SizedBox(height: 34.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: AppButton(
                      title: LocaleKeys.createAccount.tr(),
                      onPressed: _submitRegister,
                      isLoading: state.isLoading,
                    ),
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
        );
      },
    );
  }
}
