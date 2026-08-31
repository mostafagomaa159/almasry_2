import 'package:almasry_2/core/models/response/product_details/product_custom_attribute_model.dart';
import 'package:almasry_2/core/models/response/product_details/product_media_model.dart';
import 'package:almasry_2/core/models/response/product_details/product_price_model.dart';
import 'package:almasry_2/core/models/response/product_details/product_related_item_model.dart';
import 'package:almasry_2/core/models/response/product_details/product_review_model.dart';
import 'package:almasry_2/core/models/response/product_search/product_search_label_model.dart';
import 'package:almasry_2/core/utils/media_url.dart';

class ProductDetailModel {
  final String id;
  final String uid;
  final String sku;
  final String name;
  final String typeName;

  final String descriptionHtml;
  final String shortDescriptionHtml;

  final ProductBrandDetailModel? brand;
  final List<ProductCustomAttributeModel> customAttributes;
  final List<ProductSearchLabelModel> labels;

  final ProductPriceRangeModel priceRange;
  final List<ProductPriceTierModel> priceTiers;
  final double specialPrice;
  final String specialToDate;

  final String imageUrl;
  final String smallImageUrl;
  final String thumbnailUrl;
  final List<ProductMediaModel> mediaGallery;

  final String stockStatus;

  final double? onlyXLeftInStock;

  final List<ProductCategoryModel> categories;

  final double ratingSummary;

  final int reviewCount;
  final ProductReviewsModel reviews;

  final List<ProductRelatedItemModel> relatedProducts;
  final List<ProductRelatedItemModel> upsellProducts;
  final List<ProductRelatedItemModel> crosssellProducts;

  final String countryOfManufacture;
  final double? weight;

  const ProductDetailModel({
    required this.id,
    required this.uid,
    required this.sku,
    required this.name,
    required this.typeName,
    required this.descriptionHtml,
    required this.shortDescriptionHtml,
    required this.brand,
    required this.customAttributes,
    required this.labels,
    required this.priceRange,
    required this.priceTiers,
    required this.specialPrice,
    required this.specialToDate,
    required this.imageUrl,
    required this.smallImageUrl,
    required this.thumbnailUrl,
    required this.mediaGallery,
    required this.stockStatus,
    required this.onlyXLeftInStock,
    required this.categories,
    required this.ratingSummary,
    required this.reviewCount,
    required this.reviews,
    required this.relatedProducts,
    required this.upsellProducts,
    required this.crosssellProducts,
    required this.countryOfManufacture,
    required this.weight,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id']?.toString() ?? '',
      uid: json['uid']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      typeName: json['__typename']?.toString() ?? '',
      descriptionHtml: _htmlOf(json['description']),
      shortDescriptionHtml: _htmlOf(json['short_description']),
      brand: json['brand_detail'] is Map<String, dynamic>
          ? ProductBrandDetailModel.fromJson(
              json['brand_detail'] as Map<String, dynamic>,
            )
          : null,
      customAttributes:
          (json['custom_attributes'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .map(ProductCustomAttributeModel.fromJson)
              .where((attribute) => attribute.hasValue)
              .toList(),
      labels: (json['product_labels'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProductSearchLabelModel.fromJson)
          .where((label) => !label.isEmpty)
          .toList(),
      priceRange: ProductPriceRangeModel.fromJson(
        json['price_range'] as Map<String, dynamic>?,
      ),
      priceTiers: (json['price_tiers'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProductPriceTierModel.fromJson)
          .toList(),
      specialPrice: (json['special_price'] as num?)?.toDouble() ?? 0,
      specialToDate: json['special_to_date']?.toString() ?? '',
      imageUrl: mediaUrlFrom(_urlOf(json['image'])),
      smallImageUrl: mediaUrlFrom(_urlOf(json['small_image'])),
      thumbnailUrl: mediaUrlFrom(_urlOf(json['thumbnail'])),
      mediaGallery: (json['media_gallery'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProductMediaModel.fromJson)
          .where((media) => media.isRenderable)
          .toList(),
      stockStatus: json['stock_status']?.toString() ?? '',
      onlyXLeftInStock: (json['only_x_left_in_stock'] as num?)?.toDouble(),
      categories: (json['categories'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProductCategoryModel.fromJson)
          .toList(),
      ratingSummary: (json['rating_summary'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      reviews: ProductReviewsModel.fromJson(
        json['reviews'] as Map<String, dynamic>?,
      ),
      relatedProducts: _relatedFrom(json['related_products']),
      upsellProducts: _relatedFrom(json['upsell_products']),
      crosssellProducts: _relatedFrom(json['crosssell_products']),
      countryOfManufacture: json['country_of_manufacture']?.toString() ?? '',
      weight: (json['weight'] as num?)?.toDouble(),
    );
  }

  static String _htmlOf(dynamic value) {
    return (value as Map<String, dynamic>?)?['html']?.toString() ?? '';
  }

  static String _urlOf(dynamic value) {
    return (value as Map<String, dynamic>?)?['url']?.toString() ?? '';
  }

  static List<ProductRelatedItemModel> _relatedFrom(dynamic value) {
    return (value as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ProductRelatedItemModel.fromJson)
        .toList();
  }

  bool get isInStock => stockStatus.toUpperCase() == 'IN_STOCK';

  double get regularPrice => priceRange.minimumPrice.regularPrice.value;

  double get finalPrice {
    final double value = priceRange.minimumPrice.finalPrice.value;

    return value > 0 ? value : regularPrice;
  }

  String get currency {
    final String code = priceRange.minimumPrice.finalPrice.currency;

    return code.isNotEmpty
        ? code
        : priceRange.minimumPrice.regularPrice.currency;
  }

  bool get hasDiscount => regularPrice > 0 && finalPrice < regularPrice;

  int get discountPercent {
    final double reported = priceRange.minimumPrice.discount.percentOff;

    if (reported > 0) return reported.round();

    if (!hasDiscount) return 0;

    return (((regularPrice - finalPrice) / regularPrice) * 100).round();
  }

  String get brandName => brand?.name ?? '';

  String get brandId {
    for (final ProductCustomAttributeModel attribute in customAttributes) {
      if (attribute.code != 'brand') continue;

      return attribute.firstOptionId;
    }

    return '';
  }

  List<String> get galleryUrls {
    final List<String> urls = [
      if (imageUrl.trim().isNotEmpty) imageUrl,
      ...mediaGallery
          .where((media) => !media.isVideo)
          .map((media) => media.url),
    ];

    return urls.toSet().toList();
  }

  List<ProductMediaModel> get videos =>
      mediaGallery.where((media) => media.isVideo).toList();

  double get ratingOutOfFive => (ratingSummary / 20).clamp(0, 5).toDouble();

  List<ProductRelatedItemModel> get carouselProducts {
    final Map<String, ProductRelatedItemModel> unique =
        <String, ProductRelatedItemModel>{};

    for (final ProductRelatedItemModel item in [
      ...relatedProducts,
      ...upsellProducts,
      ...crosssellProducts,
    ]) {
      if (item.sku.trim().isEmpty) continue;

      unique.putIfAbsent(item.sku, () => item);
    }

    return unique.values.toList();
  }
}

class ProductBrandDetailModel {
  final String name;
  final String urlAlias;
  final String image;
  final String smallImage;

  const ProductBrandDetailModel({
    required this.name,
    required this.urlAlias,
    required this.image,
    required this.smallImage,
  });

  factory ProductBrandDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductBrandDetailModel(
      name: json['name']?.toString() ?? '',
      urlAlias: json['url_alias']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      smallImage: json['small_image']?.toString() ?? '',
    );
  }
}

class ProductCategoryModel {
  final String uid;
  final String name;
  final String urlKey;
  final String urlPath;

  const ProductCategoryModel({
    required this.uid,
    required this.name,
    required this.urlKey,
    required this.urlPath,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      uid: json['uid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      urlKey: json['url_key']?.toString() ?? '',
      urlPath: json['url_path']?.toString() ?? '',
    );
  }
}
