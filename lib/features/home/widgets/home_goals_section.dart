part of '../home_imports.dart';

class HomeGoalsSection extends StatelessWidget {
  final List<HomeSubCategoryModel> items;

  const HomeGoalsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 84.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemCount: items.length,
        separatorBuilder: (_, _) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          final item = items[index];

          return WideInfoCard(
            title: item.name,
            imagePath: item.image,
            isNetworkImage: true,
            backgroundColor: AppColors.goldTint,
          );
        },
      ),
    );
  }
}
