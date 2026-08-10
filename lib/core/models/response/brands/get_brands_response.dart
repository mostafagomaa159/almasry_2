import 'package:almasry_2/core/models/response/brands/brand_model.dart';
import 'package:almasry_2/core/models/response/brands/brands_page_info_model.dart';

class GetBrandsResponse {
  final List<BrandModel> brands;
  final BrandsPageInfoModel pageInfo;

  const GetBrandsResponse({required this.brands, required this.pageInfo});

  factory GetBrandsResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? getBrands =
        json['getBrands'] as Map<String, dynamic>?;

    final List<BrandModel> brands =
        (getBrands?['brands'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(BrandModel.fromJson)
            .toList();

    final BrandsPageInfoModel pageInfo =
        getBrands?['page_info'] is Map<String, dynamic>
        ? BrandsPageInfoModel.fromJson(
            getBrands!['page_info'] as Map<String, dynamic>,
          )
        : BrandsPageInfoModel.empty;

    return GetBrandsResponse(brands: brands, pageInfo: pageInfo);
  }
}
