part of '../auth_imports.dart';

class PhoneLoginForm extends StatelessWidget {
  final AuthState state;
  final TextEditingController phoneController;
  final FocusNode phoneFocusNode;
  final VoidCallback onSubmit;
  final VoidCallback onClearErrors;

  const PhoneLoginForm({
    super.key,
    required this.state,
    required this.phoneController,
    required this.phoneFocusNode,
    required this.onSubmit,
    required this.onClearErrors,
  });

  @override
  Widget build(BuildContext context) {
    return AuthUnderlineField(
      controller: phoneController,
      focusNode: phoneFocusNode,
      hintText: LocaleKeys.phoneNumber.tr(),
      errorText: state.emailOrPhoneError,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onChanged: (_) => onClearErrors(),
      onEditingComplete: onSubmit,
    );
  }
}
