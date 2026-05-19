part of '../home_imports.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  error,
}

class HomeState {
  final int currentBannerIndex;
  final int selectedOfferTabIndex;
  final int selectedBottomNavIndex;

  final HomeStatus status;
  final String errorMessage;

  final List<HomeSliderItemResponse> banners;
  final List<HomeSubCategoryResponse> offers;
  final List<HomeSubCategoryResponse> goals;
  final List<HomeSubCategoryResponse> concerns;
  final List<HomeBrandResponse> brands;

  const HomeState({
    this.currentBannerIndex = 0,
    this.selectedOfferTabIndex = 0,
    this.selectedBottomNavIndex = 3,
    this.status = HomeStatus.initial,
    this.errorMessage = '',
    this.banners = const [],
    this.offers = const [],
    this.goals = const [],
    this.concerns = const [],
    this.brands = const [],
  });

  HomeState copyWith({
    int? currentBannerIndex,
    int? selectedOfferTabIndex,
    int? selectedBottomNavIndex,
    HomeStatus? status,
    String? errorMessage,
    List<HomeSliderItemResponse>? banners,
    List<HomeSubCategoryResponse>? offers,
    List<HomeSubCategoryResponse>? goals,
    List<HomeSubCategoryResponse>? concerns,
    List<HomeBrandResponse>? brands,
  }) {
    return HomeState(
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
      selectedOfferTabIndex:
      selectedOfferTabIndex ?? this.selectedOfferTabIndex,
      selectedBottomNavIndex:
      selectedBottomNavIndex ?? this.selectedBottomNavIndex,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      banners: banners ?? this.banners,
      offers: offers ?? this.offers,
      goals: goals ?? this.goals,
      concerns: concerns ?? this.concerns,
      brands: brands ?? this.brands,
    );
  }
}
