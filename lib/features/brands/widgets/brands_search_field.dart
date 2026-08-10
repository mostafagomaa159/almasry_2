part of '../brands_imports.dart';

class BrandsSearchField extends StatelessWidget {
  final BrandsViewModel vm;

  const BrandsSearchField({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextField(
        controller: vm._searchController,
        onChanged: vm._onSearchChanged,
        textInputAction: TextInputAction.search,
        style: TextStyle(fontSize: 15.sp, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: LocaleKeys.brandsSearchHint.tr(),
          hintStyle: TextStyle(
            fontSize: 15.sp,
            color: AppColors.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 22.sp,
            color: AppColors.textSecondary,
          ),
          filled: true,
          fillColor: const Color(0xFFF1F1F1),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
