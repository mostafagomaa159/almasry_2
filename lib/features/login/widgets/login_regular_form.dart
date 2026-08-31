part of '../login_imports.dart';

class RegularLoginForm extends StatelessWidget {
  final LoginViewModel vm;

  const RegularLoginForm({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthUnderlineField(
          controller: vm._emailOrPhoneController,
          focusNode: vm._emailOrPhoneFocusNode,
          hintText: LocaleKeys.emailOrPhone.tr(),
          errorText: vm._authService.emailOrPhoneError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (_) => vm._clearLoginErrors(),
          onEditingComplete: vm._focusPassword,
        ),
        20.verticalSpace,
        _PasswordField(vm: vm),
        18.verticalSpace,
        _RememberMeField(vm: vm),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.vm});

  final LoginViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._passwordHiddenCubit,
      builder: (context, state) {
        final bool isPasswordHidden = state.data;

        return AuthUnderlineField(
          controller: vm._passwordController,
          focusNode: vm._passwordFocusNode,
          hintText: LocaleKeys.password.tr(),
          errorText: vm._authService.passwordError,
          obscureText: isPasswordHidden,
          textInputAction: TextInputAction.done,
          onChanged: (_) => vm._clearLoginErrors(),
          onEditingComplete: () => vm._submitRegularLogin(context),
          leading: IconButton(
            onPressed: vm._togglePasswordVisibility,
            icon: Icon(
              isPasswordHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textFormLabel,
              size: 24.sp,
            ),
          ),
        );
      },
    );
  }
}

class _RememberMeField extends StatelessWidget {
  const _RememberMeField({required this.vm});

  final LoginViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._rememberMeCubit,
      builder: (context, state) {
        return RememberMeRow(
          isChecked: state.data,
          rememberMeTitle: LocaleKeys.rememberMe.tr(),
          onCheckboxTap: vm._toggleRememberMe,
        );
      },
    );
  }
}
