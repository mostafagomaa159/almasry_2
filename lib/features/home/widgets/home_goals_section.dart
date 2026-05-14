part of '../home_imports.dart';

class HomeGoalsSection extends StatelessWidget {
  final bool isArabic;
  final List<HomeGoalModel> items;

  const HomeGoalsSection({
    super.key,
    required this.isArabic,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 102.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: isArabic,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return WideInfoCard(
            title: item.titleKey.tr(),
            imagePath: item.imagePath,
          );
        },
      ),
    );
  }
}
