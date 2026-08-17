import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  /// Optional caption drawn above the field.
  final String? label;
  final String hintText;
  final String? errorText;

  /// Set this instead of [errorText] when the field sits inside a `Form`.
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final int minLines;
  final int maxLines;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;

  const CustomAppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.label,
    this.errorText,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
    this.minLines = 1,
    this.maxLines = 1,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (label == null) return _buildField();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        _buildField(),
      ],
    );
  }

  Widget _buildField() {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      style: TextStyle(
        fontSize: 18.sp,
        color: Colors.black87,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          fontSize: 18.sp,
          color: AppColors.hintField,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: suffixIcon,
        suffixIconColor: Colors.black54,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 18.h),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderField, width: 1.4),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.redFieldFocus, width: 1.6),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.4),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.6),
        ),
        errorStyle: TextStyle(
          fontSize: 12.sp,
          color: Colors.red,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
