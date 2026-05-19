part of '../../../core_imports.dart';

class HomeBrandsDataResponse {
  final String title;
  final List<HomeBrandResponse> brands;

  const HomeBrandsDataResponse({
    required this.title,
    required this.brands,
  });

  factory HomeBrandsDataResponse.fromJson(Map<String, dynamic> json) {
    return HomeBrandsDataResponse(
      title: json['title']?.toString() ?? '',
      brands: (json['brands'] as List<dynamic>? ?? [])
          .map((e) => HomeBrandResponse.fromJson(e))
          .toList(),
    );
  }
}
