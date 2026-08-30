part of '../login_imports.dart';

class PhoneLoginForm extends StatelessWidget {
  final LoginViewModel vm;

  const PhoneLoginForm({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return AuthUnderlineField(
      controller: vm._phoneController,
      focusNode: vm._phoneFocusNode,
      hintText: LocaleKeys.phoneNumber.tr(),
      errorText: vm._data().emailOrPhoneError,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onChanged: (_) => vm._clearLoginErrors(),
      onEditingComplete: () => vm._submitPhoneLogin(context),
    );
  }
}
