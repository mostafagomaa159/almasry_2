part of '../contact_us_imports.dart';

class ContactUsForm extends StatelessWidget {
  final ContactUsViewModel vm;
  final ContactUsData data;

  const ContactUsForm({super.key, required this.vm, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ContactUsTextField(
          controller: vm._nameController,
          focusNode: vm._nameFocusNode,
          label: LocaleKeys.contactUsName.tr(),
          errorText: data.nameError,
        ),
        SizedBox(height: 18.h),
        ContactUsTextField(
          controller: vm._emailController,
          focusNode: vm._emailFocusNode,
          label: LocaleKeys.contactUsEmail.tr(),
          errorText: data.emailError,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 18.h),
        ContactUsTextField(
          controller: vm._phoneController,
          focusNode: vm._phoneFocusNode,
          label: LocaleKeys.contactUsPhone.tr(),
          errorText: data.phoneError,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 18.h),
        ContactUsTextField(
          controller: vm._commentController,
          focusNode: vm._commentFocusNode,
          label: LocaleKeys.contactUsMessage.tr(),
          errorText: data.commentError,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          minLines: 5,
          maxLines: 8,
        ),
      ],
    );
  }
}
