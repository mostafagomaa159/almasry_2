import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/features/home/model/home_concern_model.dart';
import 'package:almasry_2/features/home/model/home_goal_model.dart';
import 'package:almasry_2/features/home/model/home_service_model.dart';

class HomeMockData {
  static const List<String> banners = [
    'assets/images/Red_Big_Card.png',
    'assets/images/Red_Big_Card.png',
    'assets/images/Red_Big_Card.png',
  ];

  static List<HomeGoalModel> goals() {
    return [
      HomeGoalModel(
        titleKey: LocaleKeys.homeGoalFitness,
        imagePath: 'assets/images/Red_Big_Card.png',
      ),
      HomeGoalModel(
        titleKey: LocaleKeys.homeGoalSkinCare,
        imagePath: 'assets/images/Red_Big_Card.png',
      ),
    ];
  }

  static List<HomeConcernModel> concerns() {
    return [
      HomeConcernModel(
        titleKey: LocaleKeys.homeConcernHeadache,
        imagePath: 'assets/images/Red_Big_Card.png',
      ),
      HomeConcernModel(
        titleKey: LocaleKeys.homeConcernTitle,
        imagePath: 'assets/images/Red_Big_Card.png',
      ),
    ];
  }

  static List<HomeServiceModel> services() {
    return [
      HomeServiceModel(
        iconPath: 'assets/images/Red_Big_Card.png',
        titleKey: LocaleKeys.homeSafeShopping,
        descriptionKey: LocaleKeys.homeSafeShoppingDesc,
      ),
      HomeServiceModel(
        iconPath: 'assets/images/Red_Big_Card.png',
        titleKey: LocaleKeys.homeFastShipping,
        descriptionKey: LocaleKeys.homeFastShippingDesc,
      ),
      HomeServiceModel(
        iconPath: 'assets/images/Red_Big_Card.png',
        titleKey: LocaleKeys.homeMoneyBack,
        descriptionKey: LocaleKeys.homeMoneyBackDesc,
      ),
      HomeServiceModel(
        iconPath: 'assets/images/Red_Big_Card.png',
        titleKey: LocaleKeys.homeCustomerService,
        descriptionKey: LocaleKeys.homeCustomerServiceDesc,
      ),
    ];
  }
}
