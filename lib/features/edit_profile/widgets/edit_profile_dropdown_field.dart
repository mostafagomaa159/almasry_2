part of '../edit_profile_imports.dart';

class EditProfileDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  const EditProfileDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
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
          6.verticalSpace,
          DropdownButtonFormField<String>(
            initialValue: (value != null && value!.isNotEmpty) ? value : null,
            items: items,
            onChanged: onChanged,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.iconMuted,
            ),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPlaceholder,
              fontWeight: FontWeight.w500,
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
