import 'package:almasry_2/core/models/response/product_details/product_price_model.dart';
import 'package:almasry_2/core/utils/media_url.dart';

/// The trimmed product shape shared by `related_products`, `upsell_products`
/// and `crosssell_products` — enough for a carousel card, nothing more.
class ProductRelatedItemModel {
  final String uid;
  final String sku;
  final String name;
  final String thumbnailUrl;
  final ProductPriceModel finalPrice;

  const ProductRelatedItemModel({
    required this.uid,
    required this.sku,
    required this.name,
    required this.thumbnailUrl,
    required this.finalPrice,
  });

  factory ProductRelatedItemModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? minimumPrice =
        (json['price_range'] as Map<String, dynamic>?)?['minimum_price']
            as Map<String, dynamic>?;

    return ProductRelatedItemModel(
      uid: json['uid']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      thumbnailUrl: mediaUrlFrom(
        (json['thumbnail'] as Map<String, dynamic>?)?['url']?.toString(),
      ),
      finalPrice: ProductPriceModel.fromJson(
        minimumPrice?['final_price'] as Map<String, dynamic>?,
      ),
    );
  }
}
