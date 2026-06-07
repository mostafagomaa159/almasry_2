
import 'package:almasry_2/core/models/response/home/product_custom_attribute_response.dart';
import 'package:almasry_2/core/models/response/home/product_extension_attributes_response.dart';
import 'package:almasry_2/core/models/response/home/product_media_gallery_entry_response.dart';

class ProductResponse {
  final int id;
  final String sku;
  final String name;
  final double price;
  final ProductExtensionAttributesResponse? extensionAttributes;
  final List<ProductCustomAttributeResponse> customAttributes;
  final List<ProductMediaGalleryEntryResponse> mediaGalleryEntries;

  const ProductResponse({
    required this.id,
    required this.sku,
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

    return ProductResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sku: json['sku']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      extensionAttributes: extensionAttributes,
      customAttributes: customAttributes,
      mediaGalleryEntries: mediaGalleryEntries,
    );
  }

  String get imageUrl {
    final baseUrl = extensionAttributes?.urlBase.trim() ?? '';

    if (baseUrl.isEmpty) {
      return '';
    }

    String? imagePath;

    imagePath = _getCustomAttributeValue('image');
    if (_isValidImagePath(imagePath)) {
      return '$baseUrl$imagePath';
    }

    imagePath = _getCustomAttributeValue('small_image');
    if (_isValidImagePath(imagePath)) {
      return '$baseUrl$imagePath';
    }

    imagePath = _getCustomAttributeValue('thumbnail');
    if (_isValidImagePath(imagePath)) {
      return '$baseUrl$imagePath';
    }

    final extensionThumbnail = extensionAttributes?.thumbnail;
    if (_isValidImagePath(extensionThumbnail)) {
      return '$baseUrl$extensionThumbnail';
    }

    for (final item in mediaGalleryEntries) {
      if (_isValidImagePath(item.file)) {
        return '$baseUrl${item.file}';
      }
    }

    return '';
  }

  String get description {
    final extensionDescription = extensionAttributes?.description ?? '';
    if (extensionDescription.trim().isNotEmpty) {
      return extensionDescription.trim();
    }

    return _getCustomAttributeValue('description') ?? '';
  }



  String get shortDescription {
    return _getCustomAttributeValue('short_description') ?? '';
  }

  String? _getCustomAttributeValue(String code) {
    for (final item in customAttributes) {
      if (item.attributeCode == code && item.value != null) {
        return item.value.toString().trim();
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
