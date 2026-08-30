part of '../login_imports.dart';

class RegularLoginForm extends StatelessWidget {
  final LoginViewModel vm;

  const RegularLoginForm({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final UserModel state = vm._data();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthUnderlineField(
          controller: vm._emailOrPhoneController,
          focusNode: vm._emailOrPhoneFocusNode,
          hintText: LocaleKeys.emailOrPhone.tr(),
          errorText: state.emailOrPhoneError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (_) => vm._clearLoginErrors(),
          onEditingComplete: vm._focusPassword,
        ),
        20.verticalSpace,
        AuthUnderlineField(
          controller: vm._passwordController,
          focusNode: vm._passwordFocusNode,
          hintText: LocaleKeys.password.tr(),
          errorText: state.passwordError,
          obscureText: state.isPasswordHidden,
          textInputAction: TextInputAction.done,
          onChanged: (_) => vm._clearLoginErrors(),
          onEditingComplete: () => vm._submitRegularLogin(context),
          leading: IconButton(
            onPressed: vm._togglePasswordVisibility,
            icon: Icon(
              state.isPasswordHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textFormLabel,
              size: 24.sp,
            ),
          ),
        ),
        18.verticalSpace,
        RememberMeRow(
          isChecked: state.rememberMe,
          rememberMeTitle: LocaleKeys.rememberMe.tr(),
          onCheckboxTap: vm._toggleRememberMe,
        ),
      ],
    );
  }
}
