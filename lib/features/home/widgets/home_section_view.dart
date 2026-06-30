part of '../home_imports.dart';

class HomeSectionsView extends StatelessWidget {
  final HomeModel data;


  const HomeSectionsView({
    super.key,
    required this.data,

  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (data.offers.isNotEmpty) ...[
          HomeSectionHeader(
            title: LocaleKeys.homeOffers.tr(),
          ),
          SizedBox(height: 14.h),
          HomeOffersSection(
            isArabic: isArabic,
            items: data.offers,
          ),
          SizedBox(height: 24.h),
        ],

        if (data.categories.isNotEmpty) ...[
          HomeSectionHeader(
            title: LocaleKeys.homeCategories.tr(),
          ),
          SizedBox(height: 12.h),
          HomeCategoriesSection(
            isArabic: isArabic,
            items: data.categories,
          ),
          SizedBox(height: 24.h),
        ],

        if (data.bestSellerBlock != null) ...[
          HomeSectionHeader(
            title: LocaleKeys.homeBestSelling.tr(),
          ),
          SizedBox(height: 16.h),
          if (data.bestSellerProducts.isEmpty)
            const Center(
              child: Text('No bestseller products'),
            ),
          if (data.bestSellerProducts.isNotEmpty)
            HomeProductsSection(
              isArabic: isArabic,
              products: data.bestSellerProducts,
            ),
          SizedBox(height: 24.h),
        ],

        if (data.brands.isNotEmpty) ...[
          HomeSectionHeader(
            title: isArabic ? 'العلامات التجارية' : 'Brands',
          ),
          SizedBox(height: 12.h),
          BrandStrip(brands: data.brands),
          SizedBox(height: 24.h),
        ],

        if (data.goals.isNotEmpty) ...[
          HomeSectionHeader(
            title: LocaleKeys.homeGoals.tr(),
          ),
          SizedBox(height: 12.h),
          HomeGoalsSection(
            isArabic: isArabic,
            items: data.goals,
          ),
          SizedBox(height: 24.h),
        ],

        if (data.concerns.isNotEmpty) ...[
          HomeSectionHeader(
            title: LocaleKeys.homeConcerns.tr(),
          ),
          SizedBox(height: 12.h),
          HomeConcernsSection(
            isArabic: isArabic,
            items: data.concerns,
          ),
          SizedBox(height: 24.h),
        ],

        if (data.momBabyBlock != null && data.momBabyProducts.isNotEmpty) ...[
          HomeDynamicBlockSection(
            title: isArabic
                ? 'العناية بالام والطفل'
                : 'Mom & Baby & Child Care',
            isArabic: isArabic,
            block: data.momBabyBlock!,
            products: data.momBabyProducts,
          ),
          SizedBox(height: 24.h),
        ],

        if (data.homeCareBlock != null && data.homeCareProducts.isNotEmpty) ...[
          HomeDynamicBlockSection(
            title: isArabic ? 'العناية بالمنزل' : 'Home Care',
            isArabic: isArabic,
            block: data.homeCareBlock!,
            products: data.homeCareProducts,
          ),
          SizedBox(height: 24.h),
        ],

        if (data.feminineCareBlock != null &&
            data.feminineCareProducts.isNotEmpty) ...[
          HomeDynamicBlockSection(
            title: isArabic
                ? 'العناية النسائية'
                : 'Feminine Personal Care',
            isArabic: isArabic,
            block: data.feminineCareBlock!,
            products: data.feminineCareProducts,
          ),
          SizedBox(height: 24.h),
        ],

        if (data.menCareBlock != null && data.menCareProducts.isNotEmpty) ...[
          HomeDynamicBlockSection(
            title: isArabic ? 'العناية للرجال' : 'Men Care',
            isArabic: isArabic,
            block: data.menCareBlock!,
            products: data.menCareProducts,
          ),
          SizedBox(height: 24.h),
        ],
      ],
    );
  }
}
