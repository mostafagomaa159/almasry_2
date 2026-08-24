part of '../home_imports.dart';

class HomeQuickActionsSection extends StatelessWidget {
  const HomeQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Expanded(
            child: HomeQuickActionCard(
              title: LocaleKeys.homeSkinAnalysis.tr(),
              iconPath: AppImages.mask,
              backgroundColor: AppColors.redTintCard,
              onTap: () {},
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: HomeQuickActionCard(
              title: LocaleKeys.homeSmartSearch.tr(),
              iconPath: AppImages.ai,
              backgroundColor: AppColors.violetTint,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
