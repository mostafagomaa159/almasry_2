part of '../../../core_imports.dart';

class ProductResponse {
  final int id;
  final String name;
  final double price;
  final ProductExtensionAttributesResponse? extensionAttributes;
  final List<ProductCustomAttributeResponse> customAttributes;
  final List<ProductMediaGalleryEntryResponse> mediaGalleryEntries;

  const ProductResponse({
    required this.id,
    required this.name,
    required this.price,
    required this.extensionAttributes,
    required this.customAttributes,
    required this.mediaGalleryEntries,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final extensionAttributes = json['extension_attributes'] != null
        ? ProductExtensionAttributesResponse.fromJson(
      json['extension_attributes'] as Map<String, dynamic>,
    )
        : null;

    final customAttributes = (json['custom_attributes'] as List<dynamic>?)
        ?.map(
          (e) => ProductCustomAttributeResponse.fromJson(
        e as Map<String, dynamic>,
      ),
    )
        .toList() ??
        [];

    final mediaGalleryEntries = (json['media_gallery_entries'] as List<dynamic>?)
        ?.map(
          (e) => ProductMediaGalleryEntryResponse.fromJson(
        e as Map<String, dynamic>,
      ),
    )
        .toList() ??
        [];

    // print('================ PRODUCT JSON DEBUG ================');
    // print('RAW JSON: $json');
    // print('ID: ${json['id']}');
    // print('NAME: ${json['name']}');
    // print('TOP LEVEL IMAGE: ${json['image']}');
    // print('TOP LEVEL THUMBNAIL: ${json['thumbnail']}');
    // print('HAS extension_attributes: ${json['extension_attributes'] != null}');
    // print('URL BASE: ${extensionAttributes?.urlBase}');
    // print('EXT thumbnail: ${extensionAttributes?.thumbnail}');
    // print('HAS custom_attributes: ${json['custom_attributes'] != null}');
    // print('CUSTOM ATTRIBUTES COUNT: ${customAttributes.length}');
    // print('HAS media_gallery_entries: ${json['media_gallery_entries'] != null}');
    // print('MEDIA GALLERY COUNT: ${mediaGalleryEntries.length}');
    // print('====================================================');

    return ProductResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      extensionAttributes: extensionAttributes,
      customAttributes: customAttributes,
      mediaGalleryEntries: mediaGalleryEntries,
    );
  }


  String get imageUrl {
    final baseUrl = extensionAttributes?.urlBase.trim() ?? '';

    print('--- imageUrl getter ---');
    print('name: $name');
    print('baseUrl: $baseUrl');

    if (baseUrl.isEmpty) {
      print('baseUrl is empty');
      return '';
    }

    String? imagePath;

    imagePath = _getCustomAttributeValue('image');
    print('custom image: $imagePath');
    if (_isValidImagePath(imagePath)) {
      print('using custom image');
      return '$baseUrl$imagePath';
    }

    imagePath = _getCustomAttributeValue('small_image');
    print('small_image: $imagePath');
    if (_isValidImagePath(imagePath)) {
      print('using small_image');
      return '$baseUrl$imagePath';
    }

    imagePath = _getCustomAttributeValue('thumbnail');
    print('custom thumbnail: $imagePath');
    if (_isValidImagePath(imagePath)) {
      print('using custom thumbnail');
      return '$baseUrl$imagePath';
    }

    final extensionThumbnail = extensionAttributes?.thumbnail;
    print('extension thumbnail: $extensionThumbnail');
    print('extension thumbnail valid: ${_isValidImagePath(extensionThumbnail)}');

    if (_isValidImagePath(extensionThumbnail)) {
      print('using extension thumbnail');
      return '$baseUrl$extensionThumbnail';
    }

    for (final item in mediaGalleryEntries) {
      print('gallery file: ${item.file}');
      if (_isValidImagePath(item.file)) {
        print('using gallery file');
        return '$baseUrl${item.file}';
      }
    }

    print('no valid image found');
    return '';
  }


  String? _getCustomAttributeValue(String code) {
    for (final item in customAttributes) {
      if (item.attributeCode == code && item.value is String) {
        return (item.value as String).trim();
      }
    }
    return null;
  }

  bool _isValidImagePath(String? path) {
    if (path == null) return false;

    final cleaned = path.trim().toLowerCase();

    if (cleaned.isEmpty) return false;
    if (cleaned == 'no_selection') return false;
    if (cleaned.contains('no_selection')) return false;

    return cleaned.startsWith('/');
  }
}
