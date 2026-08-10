part of '../contact_us_imports.dart';

class ContactUsTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String? errorText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int minLines;
  final int maxLines;

  const ContactUsTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          minLines: minLines,
          maxLines: maxLines,
          style: TextStyle(fontSize: 16.sp, color: Colors.black87),
          decoration: InputDecoration(
            errorText: errorText,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFCFCFCF), width: 1.4),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFB71C1C), width: 1.6),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.4),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.6),
            ),
            errorStyle: TextStyle(fontSize: 12.sp, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
