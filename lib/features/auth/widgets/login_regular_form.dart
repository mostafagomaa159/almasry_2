part of '../auth_imports.dart';

class RegularLoginForm extends StatelessWidget {
  final UserModel  state;
  final AuthViewModel authCubit;
  final TextEditingController emailOrPhoneController;
  final TextEditingController passwordController;
  final FocusNode emailOrPhoneFocusNode;
  final FocusNode passwordFocusNode;
  final VoidCallback onSubmit;
  final VoidCallback onClearErrors;

  const RegularLoginForm({
    super.key,
    required this.state,
    required this.authCubit,
    required this.emailOrPhoneController,
    required this.passwordController,
    required this.emailOrPhoneFocusNode,
    required this.passwordFocusNode,
    required this.onSubmit,
    required this.onClearErrors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthUnderlineField(
          controller: emailOrPhoneController,
          focusNode: emailOrPhoneFocusNode,
          hintText: LocaleKeys.emailOrPhone.tr(),
          errorText: state.emailOrPhoneError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (_) => onClearErrors(),
          onEditingComplete: () {
            passwordFocusNode.requestFocus();
          },
        ),
        SizedBox(height: 20.h),
        AuthUnderlineField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          hintText: LocaleKeys.password.tr(),
          errorText: state.passwordError,
          obscureText: state.isPasswordHidden,
          textInputAction: TextInputAction.done,
          onChanged: (_) => onClearErrors(),
          onEditingComplete: onSubmit,
          leading: IconButton(
            onPressed: authCubit.togglePasswordVisibility,
            icon: Icon(
              state.isPasswordHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF4F4F4F),
              size: 24.sp,
            ),
          ),
        ),
        SizedBox(height: 18.h),
        RememberMeRow(
          isChecked: state.rememberMe,
          rememberMeTitle: LocaleKeys.rememberMe.tr(),
          onCheckboxTap: authCubit.toggleRememberMe,
        ),
      ],
    );
  }
}
