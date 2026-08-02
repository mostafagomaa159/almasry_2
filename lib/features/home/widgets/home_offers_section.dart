part of '../home_imports.dart';

class HomeOffersSection extends StatelessWidget {
  final HomeViewModel vm;
  final List<HomeSubCategoryModel> items;

  const HomeOffersSection({super.key, required this.vm, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 150.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 18.w),
        itemBuilder: (context, index) {
          final item = items[index];

          return _HomeOfferItem(
            title: item.name,
            imagePath: item.image,
            isNetworkImage: true,
            onTap: () => vm._openProductList(item),
          );
        },
      ),
    );
  }
}
