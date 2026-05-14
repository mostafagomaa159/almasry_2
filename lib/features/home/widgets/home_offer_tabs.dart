part of '../home_imports.dart';

class HomeOfferTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const HomeOfferTabs({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    final List<String> tabs = [
      LocaleKeys.homeBeautyOffers.tr(),
      LocaleKeys.homePersonalCareOffers.tr(),
      LocaleKeys.homeCareOffers.tr(),
    ];

    return SizedBox(
      height: 46.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: isArabic,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemCount: tabs.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              constraints: BoxConstraints(minWidth: 95.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryRed : AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFE8E8E8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
