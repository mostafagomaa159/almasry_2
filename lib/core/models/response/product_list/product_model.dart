import 'package:almasry_2/core/models/response/product_list/product_custom_attribute_model.dart';
import 'package:almasry_2/core/models/response/product_list/product_extension_attributes_model.dart';
import 'package:almasry_2/core/models/response/product_list/product_media_gallery_entry_model.dart';

class ProductModel {
  final int id;
  final String sku;
  final String name;
  final double price;
  final ProductExtensionAttributesModel? extensionAttributes;
  final List<ProductCustomAttributeModel> customAttributes;
  final List<ProductMediaGalleryEntryModel> mediaGalleryEntries;

  const ProductModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.extensionAttributes,
    required this.customAttributes,
    required this.mediaGalleryEntries,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final extensionAttributes = json['extension_attributes'] != null
        ? ProductExtensionAttributesModel.fromJson(
            json['extension_attributes'] as Map<String, dynamic>,
          )
        : null;

    final customAttributes =
        (json['custom_attributes'] as List<dynamic>?)
            ?.map(
              (e) => ProductCustomAttributeModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [];

    final mediaGalleryEntries =
        (json['media_gallery_entries'] as List<dynamic>?)
            ?.map(
              (e) => ProductMediaGalleryEntryModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [];

    return ProductModel(
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

  static const Set<String> _outOfStockValues = {
    'out of stock',
    'outofstock',
    'out_of_stock',
    '0',
    'false',
  };

  bool get isInStock {
    final status = extensionAttributes?.stockStatus.trim().toLowerCase() ?? '';

    if (status.isNotEmpty) {
      return !_outOfStockValues.contains(status);
    }

    final quantity = num.tryParse(
      extensionAttributes?.sellableQuantity.trim() ?? '',
    );

    if (quantity != null) {
      return quantity > 0;
    }

    return true;
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
