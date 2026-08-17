part of '../login_imports.dart';

class AuthUnderlineField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? leading;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;

  const AuthUnderlineField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.leading,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.textFieldLabel,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: leading,
            prefixIconConstraints: BoxConstraints(
              minWidth: 42.w,
              minHeight: 24.h,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.iconFavoriteInactive),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.redLink, width: 1.4),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
        if (errorText != null) ...[
          6.verticalSpace,
          Text(
            errorText!,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
