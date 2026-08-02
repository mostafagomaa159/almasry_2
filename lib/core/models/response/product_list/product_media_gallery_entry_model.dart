class ProductMediaGalleryEntryModel {
  final int id;
  final String file;
  final String mediaType;

  const ProductMediaGalleryEntryModel({
    required this.id,
    required this.file,
    required this.mediaType,
  });

  factory ProductMediaGalleryEntryModel.fromJson(Map<String, dynamic> json) {
    return ProductMediaGalleryEntryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      file: json['file']?.toString() ?? '',
      mediaType: json['media_type']?.toString() ?? '',
    );
  }
}
