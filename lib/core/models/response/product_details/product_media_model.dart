
class ProductMediaModel {
  final String url;
  final String label;
  final int position;
  final bool disabled;
  final String typeName;
  final ProductVideoContentModel? videoContent;

  const ProductMediaModel({
    required this.url,
    required this.label,
    required this.position,
    required this.disabled,
    required this.typeName,
    this.videoContent,
  });

  factory ProductMediaModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? video =
        json['video_content'] as Map<String, dynamic>?;

    return ProductMediaModel(
      url: json['url']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      position: (json['position'] as num?)?.toInt() ?? 0,
      disabled: json['disabled'] as bool? ?? false,
      typeName: json['__typename']?.toString() ?? '',
      videoContent: video == null
          ? null
          : ProductVideoContentModel.fromJson(video),
    );
  }

  bool get isVideo => videoContent != null || typeName == 'ProductVideo';

  bool get isRenderable => !disabled && url.trim().isNotEmpty;
}

class ProductVideoContentModel {
  final String mediaType;
  final String videoProvider;
  final String videoUrl;
  final String videoTitle;
  final String videoDescription;

  const ProductVideoContentModel({
    required this.mediaType,
    required this.videoProvider,
    required this.videoUrl,
    required this.videoTitle,
    required this.videoDescription,
  });

  factory ProductVideoContentModel.fromJson(Map<String, dynamic> json) {
    return ProductVideoContentModel(
      mediaType: json['media_type']?.toString() ?? '',
      videoProvider: json['video_provider']?.toString() ?? '',
      videoUrl: json['video_url']?.toString() ?? '',
      videoTitle: json['video_title']?.toString() ?? '',
      videoDescription: json['video_description']?.toString() ?? '',
    );
  }
}
