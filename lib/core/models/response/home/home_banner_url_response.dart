class HomeBannerUrlResponse {
  final String key;
  final String value;

  const HomeBannerUrlResponse({
    required this.key,
    required this.value,
  });

  factory HomeBannerUrlResponse.fromJson(Map<String, dynamic> json) {
    return HomeBannerUrlResponse(
      key: json['key']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}
