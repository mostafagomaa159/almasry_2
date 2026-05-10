class HomeState {
  final int currentBannerIndex;
  final int selectedOfferTabIndex;
  final int selectedBottomNavIndex;

  const HomeState({
    this.currentBannerIndex = 0,
    this.selectedOfferTabIndex = 0,
    this.selectedBottomNavIndex = 3,
  });

  HomeState copyWith({
    int? currentBannerIndex,
    int? selectedOfferTabIndex,
    int? selectedBottomNavIndex,
  }) {
    return HomeState(
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
      selectedOfferTabIndex:
      selectedOfferTabIndex ?? this.selectedOfferTabIndex,
      selectedBottomNavIndex:
      selectedBottomNavIndex ?? this.selectedBottomNavIndex,
    );
  }
}
