

import 'package:almasry_2/core/models/response/home/home_banner_url_model.dart';

class HomeSliderItemModel {
  final String name;
  final String image;
  final HomeBannerUrlModel? bannerUrl;

  const HomeSliderItemModel({
    required this.name,
    required this.image,
    this.bannerUrl,
  });

  factory HomeSliderItemModel.fromJson(Map<String, dynamic> json) {
    return HomeSliderItemModel(
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      bannerUrl: json['bannerUrl'] != null
          ? HomeBannerUrlModel.fromJson(json['bannerUrl'])
          : null,
    );
  }
}
