part of '../address_form_imports.dart';

/// One field of the address form: a bold dark-blue caption over an underlined
/// input.
///
/// Deliberately not `CustomAppTextField` — that one draws a filled, fully bordered
/// box, and this screen's fields are bare underlines.
///
/// A presentational leaf, so it keeps its parameters rather than taking the
/// ViewModel.
class AddressFormField extends StatelessWidget {
  /// Null for the field that sits directly under the map, where the "Address"
  /// caption already belongs to the section above it.
  final String? label;

  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;

  const AddressFormField({
    super.key,
    required this.hintText,
    this.label,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null)
          Text(
            label!,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBlue,
            ),
          ),

        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4B4B4B),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFB5B5B5),
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFDCDCDC)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.darkBlue),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryRed),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryRed),
            ),
            errorStyle: TextStyle(fontSize: 12.sp),
          ),
        ),
      ],
    );
  }
}
