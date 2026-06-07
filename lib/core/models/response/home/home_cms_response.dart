

import 'package:almasry_2/core/models/response/home/home_brands_data_response.dart';
import 'package:almasry_2/core/models/response/home/home_mobile_block_response.dart';
import 'package:almasry_2/core/models/response/home/home_slider_item_response.dart';

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
