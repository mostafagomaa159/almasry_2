part of '../home_imports.dart';

class HomeData {
  final int currentBannerIndex;
  final int selectedOfferTabIndex;
  final int selectedBottomNavIndex;

  final bool isLoading;
  final String? errorMessage;

  final List<HomeSliderItemResponse> banners;
  final List<HomeSliderItemResponse> secondaryBanners;

  final List<HomeSubCategoryResponse> offers;
  final List<HomeSubCategoryResponse> categories;
  final List<HomeSubCategoryResponse> goals;
  final List<HomeSubCategoryResponse> concerns;
  final List<HomeBrandResponse> brands;

  final HomeMobileBlockResponse? bestSellerBlock;
  final HomeMobileBlockResponse? momBabyBlock;
  final HomeMobileBlockResponse? homeCareBlock;
  final HomeMobileBlockResponse? feminineCareBlock;
  final HomeMobileBlockResponse? menCareBlock;

  final List<ProductResponse> bestSellerProducts;
  final List<ProductResponse> momBabyProducts;
  final List<ProductResponse> homeCareProducts;
  final List<ProductResponse> feminineCareProducts;
  final List<ProductResponse> menCareProducts;

  const HomeData({
    this.currentBannerIndex = 0,
    this.selectedOfferTabIndex = 0,
    this.selectedBottomNavIndex = 3,
    this.isLoading = false,
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

  HomeData copyWith({
    int? currentBannerIndex,
    int? selectedOfferTabIndex,
    int? selectedBottomNavIndex,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    List<HomeSliderItemResponse>? banners,
    List<HomeSliderItemResponse>? secondaryBanners,
    List<HomeSubCategoryResponse>? offers,
    List<HomeSubCategoryResponse>? categories,
    List<HomeSubCategoryResponse>? goals,
    List<HomeSubCategoryResponse>? concerns,
    List<HomeBrandResponse>? brands,
    HomeMobileBlockResponse? bestSellerBlock,
    HomeMobileBlockResponse? momBabyBlock,
    HomeMobileBlockResponse? homeCareBlock,
    HomeMobileBlockResponse? feminineCareBlock,
    HomeMobileBlockResponse? menCareBlock,
    List<ProductResponse>? bestSellerProducts,
    List<ProductResponse>? momBabyProducts,
    List<ProductResponse>? homeCareProducts,
    List<ProductResponse>? feminineCareProducts,
    List<ProductResponse>? menCareProducts,
  }) {
    return HomeData(
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
      selectedOfferTabIndex:
      selectedOfferTabIndex ?? this.selectedOfferTabIndex,
      selectedBottomNavIndex:
      selectedBottomNavIndex ?? this.selectedBottomNavIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
      clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
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
      feminineCareProducts:
      feminineCareProducts ?? this.feminineCareProducts,
      menCareProducts: menCareProducts ?? this.menCareProducts,
    );
  }
}
