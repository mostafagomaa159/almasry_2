part of '../home_imports.dart';

class HomeSectionsView extends StatelessWidget {
  final HomeViewModel vm;

  const HomeSectionsView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final _HomeStructure? structure = vm._structure();

    if (structure == null) return const SizedBox.shrink();

    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._productsLoadingCubit,
      builder: (context, state) {
        final bool isProductsLoading = state.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (structure.offers.isNotEmpty) ...[
              CustomAppSectionHeader(title: LocaleKeys.homeOffers.tr()),
              14.verticalSpace,
              HomeOffersSection(vm: vm, items: structure.offers),
              24.verticalSpace,
            ],

            if (structure.categories.isNotEmpty) ...[
              CustomAppSectionHeader(title: LocaleKeys.homeCategories.tr()),
              12.verticalSpace,
              HomeCategoriesSection(items: structure.categories),
              24.verticalSpace,
            ],

            if (structure.bestSellerBlock != null) ...[
              CustomAppSectionHeader(title: LocaleKeys.homeBestSelling.tr()),
              16.verticalSpace,
              if (isProductsLoading)
                CustomAppLoadingView(height: 330.h)
              else if (vm._bestSellerProducts.isEmpty)
                Center(child: Text(LocaleKeys.homeNoBestsellers.tr()))
              else
                HomeProductsSection(vm: vm, products: vm._bestSellerProducts),
              24.verticalSpace,
            ],

            if (structure.brands.isNotEmpty) ...[
              CustomAppSectionHeader(title: LocaleKeys.homeBrands.tr()),
              12.verticalSpace,
              BrandStrip(brands: structure.brands),
              24.verticalSpace,
            ],

            if (structure.goals.isNotEmpty) ...[
              CustomAppSectionHeader(title: LocaleKeys.homeGoals.tr()),
              12.verticalSpace,
              HomeGoalsSection(items: structure.goals),
              24.verticalSpace,
            ],

            if (structure.concerns.isNotEmpty) ...[
              CustomAppSectionHeader(title: LocaleKeys.homeConcerns.tr()),
              12.verticalSpace,
              HomeConcernsSection(items: structure.concerns),
              24.verticalSpace,
            ],

            if (structure.momBabyBlock != null &&
                (isProductsLoading || vm._momBabyProducts.isNotEmpty)) ...[
              HomeDynamicBlockSection(
                vm: vm,
                title: LocaleKeys.homeMomBabyCare.tr(),
                block: structure.momBabyBlock!,
                products: vm._momBabyProducts,
                isLoading: isProductsLoading,
              ),
              24.verticalSpace,
            ],

            if (structure.homeCareBlock != null &&
                (isProductsLoading || vm._homeCareProducts.isNotEmpty)) ...[
              HomeDynamicBlockSection(
                vm: vm,
                title: LocaleKeys.homeHomeCare.tr(),
                block: structure.homeCareBlock!,
                products: vm._homeCareProducts,
                isLoading: isProductsLoading,
              ),
              24.verticalSpace,
            ],

            if (structure.feminineCareBlock != null &&
                (isProductsLoading || vm._feminineCareProducts.isNotEmpty)) ...[
              HomeDynamicBlockSection(
                vm: vm,
                title: LocaleKeys.homeFeminineCare.tr(),
                block: structure.feminineCareBlock!,
                products: vm._feminineCareProducts,
                isLoading: isProductsLoading,
              ),
              24.verticalSpace,
            ],

            if (structure.menCareBlock != null &&
                (isProductsLoading || vm._menCareProducts.isNotEmpty)) ...[
              HomeDynamicBlockSection(
                vm: vm,
                title: LocaleKeys.homeMenCare.tr(),
                block: structure.menCareBlock!,
                products: vm._menCareProducts,
                isLoading: isProductsLoading,
              ),
              24.verticalSpace,
            ],
          ],
        );
      },
    );
  }
}
