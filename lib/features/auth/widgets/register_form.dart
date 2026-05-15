part of '../auth_imports.dart';


class RegisterForm extends StatelessWidget {
  final AuthState state;
  final AuthCubit authCubit;

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final FocusNode firstNameFocusNode;
  final FocusNode lastNameFocusNode;
  final FocusNode phoneFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  final VoidCallback onSubmit;
  final VoidCallback onClearErrors;

  const RegisterForm({
    super.key,
    required this.state,
    required this.authCubit,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.firstNameFocusNode,
    required this.lastNameFocusNode,
    required this.phoneFocusNode,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.onSubmit,
    required this.onClearErrors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: firstNameController,
          focusNode: firstNameFocusNode,
          hintText: LocaleKeys.firstName.tr(),
          errorText: state.firstNameError,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          onChanged: (_) => onClearErrors(),
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
          onChanged: (_) => onClearErrors(),
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
          onChanged: (_) => onClearErrors(),
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
          onChanged: (_) => onClearErrors(),
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
          onChanged: (_) => onClearErrors(),
          onEditingComplete: onSubmit,
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
        const PasswordRules(),
        SizedBox(height: 34.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: AppButton(
            title: LocaleKeys.createAccount.tr(),
            onPressed: onSubmit,
            isLoading: state.isLoading,
          ),
        ),
      ],
    );
  }
}
