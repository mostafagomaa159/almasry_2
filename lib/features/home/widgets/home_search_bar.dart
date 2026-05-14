part of '../home_imports.dart';


class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        textAlign: TextAlign.start,
        textDirection: Directionality.of(context),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: LocaleKeys.homeSearch.tr(),
          hintStyle: TextStyle(
            fontSize: 15.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 10.h,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}
