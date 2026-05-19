part of '../home_imports.dart';

class HomeMockData {
  static const List<String> banners = [
    AppImages.redBigCard,
    AppImages.redBigCard,
    AppImages.redBigCard,
  ];

  static List<HomeGoalModel> goals() {
    return [
      const HomeGoalModel(
        titleKey: LocaleKeys.homeGoalFitness,
        imagePath: AppImages.redBigCard,
      ),
      const HomeGoalModel(
        titleKey: LocaleKeys.homeGoalSkinCare,
        imagePath: AppImages.redBigCard,
      ),
    ];
  }

  static List<HomeConcernModel> concerns() {
    return [
      const HomeConcernModel(
        titleKey: LocaleKeys.homeConcernHeadache,
        imagePath: AppImages.redBigCard,
      ),
      const HomeConcernModel(
        titleKey: LocaleKeys.homeConcernTitle,
        imagePath: AppImages.redBigCard,
      ),
    ];
  }

  static List<HomeServiceModel> services() {
    return [
      const HomeServiceModel(
        iconPath: AppImages.redBigCard,
        titleKey: LocaleKeys.homeSafeShopping,
        descriptionKey: LocaleKeys.homeSafeShoppingDesc,
      ),
      const HomeServiceModel(
        iconPath: AppImages.redBigCard,
        titleKey: LocaleKeys.homeFastShipping,
        descriptionKey: LocaleKeys.homeFastShippingDesc,
      ),
      const HomeServiceModel(
        iconPath: AppImages.redBigCard,
        titleKey: LocaleKeys.homeMoneyBack,
        descriptionKey: LocaleKeys.homeMoneyBackDesc,
      ),
      const HomeServiceModel(
        iconPath: AppImages.redBigCard,
        titleKey: LocaleKeys.homeCustomerService,
        descriptionKey: LocaleKeys.homeCustomerServiceDesc,
      ),
    ];
  }
}
