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
          14.verticalSpace,
          HomeOffersSection(vm: vm, items: data.offers),
          24.verticalSpace,
        ],

        if (data.categories.isNotEmpty) ...[
          HomeSectionHeader(title: LocaleKeys.homeCategories.tr()),
          12.verticalSpace,
          HomeCategoriesSection(items: data.categories),
          24.verticalSpace,
        ],

        if (data.bestSellerBlock != null) ...[
          HomeSectionHeader(title: LocaleKeys.homeBestSelling.tr()),
          16.verticalSpace,
          if (data.isProductsLoading)
            AppLoadingView(height: 330.h)
          else if (data.bestSellerProducts.isEmpty)
            Center(child: Text(LocaleKeys.homeNoBestsellers.tr()))
          else
            HomeProductsSection(vm: vm, products: data.bestSellerProducts),
          24.verticalSpace,
        ],

        if (data.brands.isNotEmpty) ...[
          HomeSectionHeader(title: LocaleKeys.homeBrands.tr()),
          12.verticalSpace,
          BrandStrip(brands: data.brands),
          24.verticalSpace,
        ],

        if (data.goals.isNotEmpty) ...[
          HomeSectionHeader(title: LocaleKeys.homeGoals.tr()),
          12.verticalSpace,
          HomeGoalsSection(items: data.goals),
          24.verticalSpace,
        ],

        if (data.concerns.isNotEmpty) ...[
          HomeSectionHeader(title: LocaleKeys.homeConcerns.tr()),
          12.verticalSpace,
          HomeConcernsSection(items: data.concerns),
          24.verticalSpace,
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
          24.verticalSpace,
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
          24.verticalSpace,
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
          24.verticalSpace,
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
          24.verticalSpace,
        ],
      ],
    );
  }
}
