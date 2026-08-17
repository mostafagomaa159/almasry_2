part of '../contact_us_imports.dart';

class ContactUsForm extends StatelessWidget {
  final ContactUsViewModel vm;

  const ContactUsForm({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: vm._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppTextField(
            controller: vm._nameController,
            focusNode: vm._nameFocusNode,
            label: LocaleKeys.contactUsName.tr(),
            hintText: '',
            validator: vm._validateName,
          ),
          18.verticalSpace,
          CustomAppTextField(
            controller: vm._emailController,
            focusNode: vm._emailFocusNode,
            label: LocaleKeys.contactUsEmail.tr(),
            hintText: '',
            validator: vm._validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          18.verticalSpace,
          CustomAppTextField(
            controller: vm._phoneController,
            focusNode: vm._phoneFocusNode,
            label: LocaleKeys.contactUsPhone.tr(),
            hintText: '',
            validator: vm._validatePhone,
            keyboardType: TextInputType.phone,
          ),
          18.verticalSpace,
          CustomAppTextField(
            controller: vm._commentController,
            focusNode: vm._commentFocusNode,
            label: LocaleKeys.contactUsMessage.tr(),
            hintText: '',
            validator: vm._validateComment,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: 5,
            maxLines: 8,
          ),
        ],
      ),
    );
  }
}
