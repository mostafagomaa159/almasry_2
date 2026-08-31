part of '../register_imports.dart';

class RegisterForm extends StatelessWidget {
  final RegisterViewModel vm;

  const RegisterForm({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._validationCubit,
      builder: (context, _) => _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomAppTextField(
          controller: vm._firstNameController,
          focusNode: vm._firstNameFocusNode,
          hintText: LocaleKeys.firstName.tr(),
          errorText: vm._authService.firstNameError,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          onChanged: (_) => vm._clearRegisterErrors(),
          onEditingComplete: vm._focusLastName,
        ),
        18.verticalSpace,
        CustomAppTextField(
          controller: vm._lastNameController,
          focusNode: vm._lastNameFocusNode,
          hintText: LocaleKeys.lastName.tr(),
          errorText: vm._authService.lastNameError,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          onChanged: (_) => vm._clearRegisterErrors(),
          onEditingComplete: vm._focusPhone,
        ),
        18.verticalSpace,
        CustomAppTextField(
          controller: vm._phoneController,
          focusNode: vm._phoneFocusNode,
          hintText: LocaleKeys.phoneNumber.tr(),
          errorText: vm._authService.phoneError,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onChanged: (_) => vm._clearRegisterErrors(),
          onEditingComplete: vm._focusEmail,
        ),
        18.verticalSpace,
        CustomAppTextField(
          controller: vm._emailController,
          focusNode: vm._emailFocusNode,
          hintText: LocaleKeys.email.tr(),
          errorText: vm._authService.emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (_) => vm._clearRegisterErrors(),
          onEditingComplete: vm._focusPassword,
        ),
        18.verticalSpace,
        _PasswordField(vm: vm),
        const PasswordRules(),
        34.verticalSpace,
        _SubmitButton(vm: vm),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.vm});

  final RegisterViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._passwordHiddenCubit,
      builder: (context, state) {
        final bool isPasswordHidden = state.data;

        return CustomAppTextField(
          controller: vm._passwordController,
          focusNode: vm._passwordFocusNode,
          hintText: LocaleKeys.password.tr(),
          errorText: vm._authService.passwordError,
          obscureText: isPasswordHidden,
          textInputAction: TextInputAction.done,
          onChanged: (_) => vm._clearRegisterErrors(),
          onEditingComplete: () => vm._submitRegister(context),
          suffixIcon: IconButton(
            onPressed: vm._togglePasswordVisibility,
            icon: Icon(
              isPasswordHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.black54,
              size: 24.sp,
            ),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.vm});

  final RegisterViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._loadingCubit,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: CustomAppButton(
            title: LocaleKeys.createAccount.tr(),
            onPressed: () => vm._submitRegister(context),
            isLoading: state.data,
          ),
        );
      },
    );
  }
}
