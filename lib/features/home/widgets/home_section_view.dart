part of '../home_imports.dart';

class HomeSectionsView extends StatelessWidget {
  final HomeViewModel vm;

  const HomeSectionsView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final data = vm._data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (data.offers.isNotEmpty) ...[
          HomeSectionHeader(title: LocaleKeys.homeOffers.tr()),
          SizedBox(height: 14.h),
          HomeOffersSection(vm: vm, items: data.offers),
          SizedBox(height: 24.h),
        ],

        if (data.categories.isNotEmpty) ...[
          HomeSectionHeader(title: LocaleKeys.homeCategories.tr()),
          SizedBox(height: 12.h),
          HomeCategoriesSection(items: data.categories),
          SizedBox(height: 24.h),
        ],

        if (data.bestSellerBlock != null) ...[
          HomeSectionHeader(title: LocaleKeys.homeBestSelling.tr()),
          SizedBox(height: 16.h),
          if (data.isProductsLoading)
            const HomeProductsLoader()
          else if (data.bestSellerProducts.isEmpty)
            Center(child: Text(LocaleKeys.homeNoBestsellers.tr()))
          else
            HomeProductsSection(vm: vm, products: data.bestSellerProducts),
          SizedBox(height: 24.h),
        ],

        if (data.brands.isNotEmpty) ...[
          HomeSectionHeader(title: LocaleKeys.homeBrands.tr()),
          SizedBox(height: 12.h),
          BrandStrip(brands: data.brands),
          SizedBox(height: 24.h),
        ],

        if (data.goals.isNotEmpty) ...[
          HomeSectionHeader(title: LocaleKeys.homeGoals.tr()),
          SizedBox(height: 12.h),
          HomeGoalsSection(items: data.goals),
          SizedBox(height: 24.h),
        ],

        if (data.concerns.isNotEmpty) ...[
          HomeSectionHeader(title: LocaleKeys.homeConcerns.tr()),
          SizedBox(height: 12.h),
          HomeConcernsSection(items: data.concerns),
          SizedBox(height: 24.h),
        ],

        if (data.momBabyBlock != null &&
            (data.isProductsLoading || data.momBabyProducts.isNotEmpty)) ...[
          HomeDynamicBlockSection(
            vm: vm,
            title: LocaleKeys.homeMomBabyCare.tr(),
            block: data.momBabyBlock!,
            products: data.momBabyProducts,
            isLoading: data.isProductsLoading,
          ),
          SizedBox(height: 24.h),
        ],

        if (data.homeCareBlock != null &&
            (data.isProductsLoading || data.homeCareProducts.isNotEmpty)) ...[
          HomeDynamicBlockSection(
            vm: vm,
            title: LocaleKeys.homeHomeCare.tr(),
            block: data.homeCareBlock!,
            products: data.homeCareProducts,
            isLoading: data.isProductsLoading,
          ),
          SizedBox(height: 24.h),
        ],

        if (data.feminineCareBlock != null &&
            (data.isProductsLoading ||
                data.feminineCareProducts.isNotEmpty)) ...[
          HomeDynamicBlockSection(
            vm: vm,
            title: LocaleKeys.homeFeminineCare.tr(),
            block: data.feminineCareBlock!,
            products: data.feminineCareProducts,
            isLoading: data.isProductsLoading,
          ),
          SizedBox(height: 24.h),
        ],

        if (data.menCareBlock != null &&
            (data.isProductsLoading || data.menCareProducts.isNotEmpty)) ...[
          HomeDynamicBlockSection(
            vm: vm,
            title: LocaleKeys.homeMenCare.tr(),
            block: data.menCareBlock!,
            products: data.menCareProducts,
            isLoading: data.isProductsLoading,
          ),
          SizedBox(height: 24.h),
        ],
      ],
    );
  }
}
