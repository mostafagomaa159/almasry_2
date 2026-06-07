
class ProductMediaGalleryEntryResponse {
  final int id;
  final String file;
  final String mediaType;

  const ProductMediaGalleryEntryResponse({
    required this.id,
    required this.file,
    required this.mediaType,
  });

  factory ProductMediaGalleryEntryResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProductMediaGalleryEntryResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      file: json['file']?.toString() ?? '',
      mediaType: json['media_type']?.toString() ?? '',
    );
  }
}
