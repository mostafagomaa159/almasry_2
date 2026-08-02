import 'home_brand_model.dart';

class HomeBrandsDataModel {
  final String title;
  final List<HomeBrandModel> brands;

  const HomeBrandsDataModel({required this.title, required this.brands});

  factory HomeBrandsDataModel.fromJson(Map<String, dynamic> json) {
    return HomeBrandsDataModel(
      title: json['title']?.toString() ?? '',
      brands: (json['brands'] as List<dynamic>? ?? [])
          .map((e) => HomeBrandModel.fromJson(e))
          .toList(),
    );
  }
}
