
import 'package:almasry_2/core/models/response/home/product_custom_attribute_model.dart';
import 'package:almasry_2/core/models/response/home/product_extension_attributes_model.dart';
import 'package:almasry_2/core/models/response/home/product_media_gallery_entry_model.dart';

class ProductItemModel {
  final int id;
  final String sku;
  final String name;
  final num price;
  final ProductExtensionAttributesModel? extensionAttributes;
  final List<ProductCustomAttributeModel> customAttributes;
  final List<ProductMediaGalleryEntryModel> mediaGalleryEntries;

  const ProductItemModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.extensionAttributes,
    required this.customAttributes,
    required this.mediaGalleryEntries,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sku: json['sku']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?) ?? 0,
      extensionAttributes: json['extension_attributes'] != null
          ? ProductExtensionAttributesModel.fromJson(
        json['extension_attributes'],
      )
          : null,
      customAttributes: (json['custom_attributes'] as List<dynamic>? ?? [])
          .map((e) => ProductCustomAttributeModel.fromJson(e))
          .toList(),
      mediaGalleryEntries: (json['media_gallery_entries'] as List<dynamic>? ?? [])
          .map((e) => ProductMediaGalleryEntryModel.fromJson(e))
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
