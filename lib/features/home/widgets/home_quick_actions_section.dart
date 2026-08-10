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
              backgroundColor: const Color(0xFFFDEBEC),
              onTap: () {},
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: HomeQuickActionCard(
              title: LocaleKeys.homeSmartSearch.tr(),
              iconPath: AppImages.ai,
              backgroundColor: const Color(0xFFF3F0FF),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
