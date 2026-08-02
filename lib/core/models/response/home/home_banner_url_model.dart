class HomeBannerUrlModel {
  final String key;
  final String value;

  const HomeBannerUrlModel({required this.key, required this.value});

  factory HomeBannerUrlModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerUrlModel(
      key: json['key']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}
