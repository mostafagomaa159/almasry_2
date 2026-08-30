part of '../register_imports.dart';

class RegisterForm extends StatelessWidget {
  final RegisterViewModel vm;

  const RegisterForm({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<UserModel>, GenericState<UserModel>>(
      bloc: vm._authCubit,
      builder: (context, _) => _buildForm(context, vm._data()),
    );
  }

  Widget _buildForm(BuildContext context, UserModel state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomAppTextField(
          controller: vm._firstNameController,
          focusNode: vm._firstNameFocusNode,
          hintText: LocaleKeys.firstName.tr(),
          errorText: state.firstNameError,
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
          errorText: state.lastNameError,
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
          errorText: state.phoneError,
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
          errorText: state.emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (_) => vm._clearRegisterErrors(),
          onEditingComplete: vm._focusPassword,
        ),
        18.verticalSpace,
        CustomAppTextField(
          controller: vm._passwordController,
          focusNode: vm._passwordFocusNode,
          hintText: LocaleKeys.password.tr(),
          errorText: state.passwordError,
          obscureText: state.isPasswordHidden,
          textInputAction: TextInputAction.done,
          onChanged: (_) => vm._clearRegisterErrors(),
          onEditingComplete: () => vm._submitRegister(context),
          suffixIcon: IconButton(
            onPressed: vm._togglePasswordVisibility,
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
        34.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: CustomAppButton(
            title: LocaleKeys.createAccount.tr(),
            onPressed: () => vm._submitRegister(context),
            isLoading: state.isLoading,
          ),
        ),
      ],
    );
  }
}
