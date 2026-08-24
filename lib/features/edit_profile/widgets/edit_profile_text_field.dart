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
              color: AppColors.navyProfile,
            ),
          ),
          8.verticalSpace,
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            textAlign: textAlign,
            readOnly: readOnly,
            onChanged: onChanged,
            onTap: onTap,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPlaceholder,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textDisabled,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: EdgeInsets.only(bottom: 10.h),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.textHint, width: 1),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.redAction, width: 1.2),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.textHint, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
