part of '../home_imports.dart';

class HomeQuickActionsSection extends StatelessWidget {
  const HomeQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Expanded(
            child: HomeQuickActionCard(
              title: isArabic ? 'تحليل البشرة' : 'Skin Analysis',
              iconPath: AppImages.mask,
              backgroundColor: const Color(0xFFFDEBEC),
              onTap: () {},
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: HomeQuickActionCard(
              title: isArabic ? 'البحث الذكي' : 'Smart Search',
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
