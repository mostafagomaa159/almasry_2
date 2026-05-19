part of '../../../core_imports.dart';


class HomeSliderItemResponse {
  final String name;
  final String image;
  final HomeBannerUrlResponse? bannerUrl;

  const HomeSliderItemResponse({
    required this.name,
    required this.image,
    this.bannerUrl,
  });

  factory HomeSliderItemResponse.fromJson(Map<String, dynamic> json) {
    return HomeSliderItemResponse(
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      bannerUrl: json['bannerUrl'] != null
          ? HomeBannerUrlResponse.fromJson(json['bannerUrl'])
          : null,
    );
  }
}
