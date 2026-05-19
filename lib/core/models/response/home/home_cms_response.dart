part of '../../../core_imports.dart';


class HomeCmsResponse {
  final List<HomeSliderItemResponse> slider;
  final HomeMobileBlockResponse? mobileBlock;
  final HomeBrandsDataResponse? brandsData;

  const HomeCmsResponse({
    required this.slider,
    this.mobileBlock,
    this.brandsData,
  });

  factory HomeCmsResponse.fromJson(Map<String, dynamic> json) {
    return HomeCmsResponse(
      slider: (json['slider'] as List<dynamic>? ?? [])
          .map((e) => HomeSliderItemResponse.fromJson(e))
          .toList(),
      mobileBlock: json['mobileBlock'] != null
          ? HomeMobileBlockResponse.fromJson(json['mobileBlock'])
          : null,
      brandsData: json['brandsData'] != null
          ? HomeBrandsDataResponse.fromJson(json['brandsData'])
          : null,
    );
  }
}
