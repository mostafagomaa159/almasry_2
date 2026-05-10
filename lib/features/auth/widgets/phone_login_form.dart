import 'package:almasry_2/core/core.dart';
import 'package:almasry_2/features/auth/view_model/auth_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: phoneController,
          focusNode: phoneFocusNode,
          hintText: LocaleKeys.phoneNumber.tr(),
          errorText: state.emailOrPhoneError,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onChanged: (_) => onClearErrors(),
          onEditingComplete: onSubmit,
        ),
        SizedBox(height: 60.h),
        AppButton(
          title: LocaleKeys.sendVerificationCode.tr(),
          onPressed: onSubmit,
          isLoading: state.isLoading,
        ),
      ],
    );
  }
}
