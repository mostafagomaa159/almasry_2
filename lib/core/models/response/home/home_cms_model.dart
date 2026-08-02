import 'package:almasry_2/core/models/response/home/home_brands_data_model.dart';
import 'package:almasry_2/core/models/response/home/home_mobile_block_model.dart';
import 'package:almasry_2/core/models/response/home/home_slider_item_model.dart';

class HomeCmsModel {
  final List<HomeSliderItemModel> slider;
  final HomeMobileBlockModel? mobileBlock;
  final HomeBrandsDataModel? brandsData;

  const HomeCmsModel({required this.slider, this.mobileBlock, this.brandsData});

  factory HomeCmsModel.fromJson(Map<String, dynamic> json) {
    return HomeCmsModel(
      slider: (json['slider'] as List<dynamic>? ?? [])
          .map((e) => HomeSliderItemModel.fromJson(e))
          .toList(),
      mobileBlock: json['mobileBlock'] != null
          ? HomeMobileBlockModel.fromJson(json['mobileBlock'])
          : null,
      brandsData: json['brandsData'] != null
          ? HomeBrandsDataModel.fromJson(json['brandsData'])
          : null,
    );
  }
}
