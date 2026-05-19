part of '../edit_profile_imports.dart';

class EditProfileTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final ValueChanged<String> onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const EditProfileTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF17375E),
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            textAlign: textAlign,
            readOnly: readOnly,
            onChanged: onChanged,
            onTap: onTap,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF9A9A9A),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFFB0B0B0),
                fontWeight: FontWeight.w500,
              ),
              contentPadding: EdgeInsets.only(bottom: 10.h),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB9B9B9), width: 1),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFF2D2D), width: 1.2),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB9B9B9), width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
