part of '../home_imports.dart';

class HomeConcernsSection extends StatelessWidget {
  final bool isArabic;
  final List<HomeSubCategoryModel> items;

  const HomeConcernsSection({
    super.key,
    required this.isArabic,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

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
            title: item.name,
            imagePath: item.image,
            isNetworkImage: true,
          );
        },
      ),
    );
  }
}
