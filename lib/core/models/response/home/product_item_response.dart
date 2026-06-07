
import 'package:almasry_2/core/models/response/home/product_custom_attribute_response.dart';
import 'package:almasry_2/core/models/response/home/product_extension_attributes_response.dart';
import 'package:almasry_2/core/models/response/home/product_media_gallery_entry_response.dart';

class ProductItemResponse {
  final int id;
  final String sku;
  final String name;
  final num price;
  final ProductExtensionAttributesResponse? extensionAttributes;
  final List<ProductCustomAttributeResponse> customAttributes;
  final List<ProductMediaGalleryEntryResponse> mediaGalleryEntries;

  const ProductItemResponse({
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.extensionAttributes,
    required this.customAttributes,
    required this.mediaGalleryEntries,
  });

  factory ProductItemResponse.fromJson(Map<String, dynamic> json) {
    return ProductItemResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sku: json['sku']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?) ?? 0,
      extensionAttributes: json['extension_attributes'] != null
          ? ProductExtensionAttributesResponse.fromJson(
        json['extension_attributes'],
      )
          : null,
      customAttributes: (json['custom_attributes'] as List<dynamic>? ?? [])
          .map((e) => ProductCustomAttributeResponse.fromJson(e))
          .toList(),
      mediaGalleryEntries: (json['media_gallery_entries'] as List<dynamic>? ?? [])
          .map((e) => ProductMediaGalleryEntryResponse.fromJson(e))
          .toList(),
    );
  }

  String get imageUrl {
    final base = extensionAttributes?.urlBase ?? '';
    final thumb = extensionAttributes?.thumbnail ?? '';

    if (base.isNotEmpty && thumb.isNotEmpty) {
      return '$base$thumb';
    }

    final imageAttr = customAttributes.where((e) => e.attributeCode == 'image');
    if (imageAttr.isNotEmpty && base.isNotEmpty) {
      return '$base${imageAttr.first.value}';
    }

    return '';
  }

  num get priceAfter => extensionAttributes?.priceAfter ?? price;
  num get priceBefore => extensionAttributes?.priceBefore ?? price;
  bool get hasDiscount => priceBefore > priceAfter;
  String get stockStatus => extensionAttributes?.stockStatus ?? '';
  bool get isInStock => stockStatus.toLowerCase().contains('in stock');
}
