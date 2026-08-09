part of '../../../../features/home/home_imports.dart';

class HomeModel {
  final int currentBannerIndex;
  final int selectedOfferTabIndex;
  final int selectedBottomNavIndex;

  final bool isLoading;

  /// True between the CMS response landing and the section products arriving,
  /// so the page can render while the product rows are still in flight.
  final bool isProductsLoading;

  final String? errorMessage;

  final List<HomeSliderItemModel> banners;
  final List<HomeSliderItemModel> secondaryBanners;

  final List<HomeSubCategoryModel> offers;
  final List<HomeSubCategoryModel> categories;
  final List<HomeSubCategoryModel> goals;
  final List<HomeSubCategoryModel> concerns;
  final List<HomeBrandModel> brands;

  final HomeMobileBlockModel? bestSellerBlock;
  final HomeMobileBlockModel? momBabyBlock;
  final HomeMobileBlockModel? homeCareBlock;
  final HomeMobileBlockModel? feminineCareBlock;
  final HomeMobileBlockModel? menCareBlock;

  final List<ProductModel> bestSellerProducts;
  final List<ProductModel> momBabyProducts;
  final List<ProductModel> homeCareProducts;
  final List<ProductModel> feminineCareProducts;
  final List<ProductModel> menCareProducts;

  const HomeModel({
    this.currentBannerIndex = 0,
    this.selectedOfferTabIndex = 0,
    this.selectedBottomNavIndex = 0,
    this.isLoading = false,
    this.isProductsLoading = false,
    this.errorMessage,
    this.banners = const [],
    this.secondaryBanners = const [],
    this.offers = const [],
    this.categories = const [],
    this.goals = const [],
    this.concerns = const [],
    this.brands = const [],
    this.bestSellerBlock,
    this.momBabyBlock,
    this.homeCareBlock,
    this.feminineCareBlock,
    this.menCareBlock,
    this.bestSellerProducts = const [],
    this.momBabyProducts = const [],
    this.homeCareProducts = const [],
    this.feminineCareProducts = const [],
    this.menCareProducts = const [],
  });

  HomeModel copyWith({
    int? currentBannerIndex,
    int? selectedOfferTabIndex,
    int? selectedBottomNavIndex,
    bool? isLoading,
    bool? isProductsLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    List<HomeSliderItemModel>? banners,
    List<HomeSliderItemModel>? secondaryBanners,
    List<HomeSubCategoryModel>? offers,
    List<HomeSubCategoryModel>? categories,
    List<HomeSubCategoryModel>? goals,
    List<HomeSubCategoryModel>? concerns,
    List<HomeBrandModel>? brands,
    HomeMobileBlockModel? bestSellerBlock,
    HomeMobileBlockModel? momBabyBlock,
    HomeMobileBlockModel? homeCareBlock,
    HomeMobileBlockModel? feminineCareBlock,
    HomeMobileBlockModel? menCareBlock,
    List<ProductModel>? bestSellerProducts,
    List<ProductModel>? momBabyProducts,
    List<ProductModel>? homeCareProducts,
    List<ProductModel>? feminineCareProducts,
    List<ProductModel>? menCareProducts,
  }) {
    return HomeModel(
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
      selectedOfferTabIndex:
          selectedOfferTabIndex ?? this.selectedOfferTabIndex,
      selectedBottomNavIndex:
          selectedBottomNavIndex ?? this.selectedBottomNavIndex,
      isLoading: isLoading ?? this.isLoading,
      isProductsLoading: isProductsLoading ?? this.isProductsLoading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      banners: banners ?? this.banners,
      secondaryBanners: secondaryBanners ?? this.secondaryBanners,
      offers: offers ?? this.offers,
      categories: categories ?? this.categories,
      goals: goals ?? this.goals,
      concerns: concerns ?? this.concerns,
      brands: brands ?? this.brands,
      bestSellerBlock: bestSellerBlock ?? this.bestSellerBlock,
      momBabyBlock: momBabyBlock ?? this.momBabyBlock,
      homeCareBlock: homeCareBlock ?? this.homeCareBlock,
      feminineCareBlock: feminineCareBlock ?? this.feminineCareBlock,
      menCareBlock: menCareBlock ?? this.menCareBlock,
      bestSellerProducts: bestSellerProducts ?? this.bestSellerProducts,
      momBabyProducts: momBabyProducts ?? this.momBabyProducts,
      homeCareProducts: homeCareProducts ?? this.homeCareProducts,
      feminineCareProducts: feminineCareProducts ?? this.feminineCareProducts,
      menCareProducts: menCareProducts ?? this.menCareProducts,
    );
  }
}
