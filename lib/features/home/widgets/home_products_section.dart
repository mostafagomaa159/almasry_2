part of '../home_imports.dart';

class HomeProductsSection extends StatelessWidget {
  final bool isArabic;
  final int itemCount;
  final String sectionKey;

  const HomeProductsSection({
    super.key,
    required this.isArabic,
    required this.sectionKey,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: isArabic,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return ProductCard(
            productId: '${sectionKey}_product_$index',
            imagePath: AppImages.redBigCard,
            title: LocaleKeys.homeProductTitle.tr(),
            price: LocaleKeys.homePrice.tr(),
            oldPrice: LocaleKeys.homeOldPrice.tr(),
            category: LocaleKeys.productDetailsCategoryWomenClothing.tr(),
            description: LocaleKeys.productDetailsDescriptionValue.tr(),
            discountText: LocaleKeys.homeDiscountBadge.tr(),
            pointsText: LocaleKeys.homePoints.tr(),
            rating: 3.6,
          );
        },
      ),
    );
  }
}
