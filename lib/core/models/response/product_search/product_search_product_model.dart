import 'package:almasry_2/core/models/response/product_search/product_search_label_model.dart';

class ProductSearchProductModel {
  final String id;
  final String typeId;
  final String name;
  final String sku;
  final String stockStatus;

  final double sellableQuantity;

  final String webrotatePath;
  final String webrotateJson;
  final String imageUrl;
  final double regularPrice;
  final double finalPrice;
  final List<ProductSearchLabelModel> labels;

  const ProductSearchProductModel({
    required this.id,
    required this.typeId,
    required this.name,
    required this.sku,
    required this.stockStatus,
    required this.sellableQuantity,
    required this.webrotatePath,
    required this.webrotateJson,
    required this.imageUrl,
    required this.regularPrice,
    required this.finalPrice,
    required this.labels,
  });

  factory ProductSearchProductModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? minimumPrice =
        (json['price_range'] as Map<String, dynamic>?)?['minimum_price']
            as Map<String, dynamic>?;

    final double regularPrice = _priceFrom(minimumPrice, 'regular_price');
    final double finalPrice = _priceFrom(minimumPrice, 'final_price');

    final List<ProductSearchLabelModel> labels =
        (json['product_labels'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(ProductSearchLabelModel.fromJson)
            .where((label) => !label.isEmpty)
            .toList();

    return ProductSearchProductModel(
      id: json['id']?.toString() ?? '',
      typeId: json['type_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      stockStatus: json['stock_status']?.toString() ?? '',
      sellableQuantity:
          double.tryParse(json['sellable_quantity']?.toString() ?? '') ?? 0,
      webrotatePath: json['webrotate_path']?.toString() ?? '',
      webrotateJson: json['webrotate_json']?.toString() ?? '',
      imageUrl:
          (json['image'] as Map<String, dynamic>?)?['url']?.toString() ?? '',
      regularPrice: regularPrice,

      /// Some rows come back without a final price; the regular one still
      /// prices the product.
      finalPrice: finalPrice > 0 ? finalPrice : regularPrice,
      labels: labels,
    );
  }

  static double _priceFrom(Map<String, dynamic>? minimumPrice, String key) {
    final Map<String, dynamic>? price =
        minimumPrice?[key] as Map<String, dynamic>?;

    return (price?['value'] as num?)?.toDouble() ?? 0;
  }

  /// `stock_status` is the field the storefront sells on — `sellable_quantity`
  /// can read 0 on a product Magento still considers in stock.
  bool get isOutOfStock => stockStatus.toUpperCase() != 'IN_STOCK';

  bool get hasDiscount => regularPrice > 0 && finalPrice < regularPrice;

  /// `null` when the product isn't discounted, so the card can drop the strip
  /// entirely instead of printing "0%".
  int? get discountPercent {
    if (!hasDiscount) return null;

    final int percent = (((regularPrice - finalPrice) / regularPrice) * 100)
        .round();

    return percent > 0 ? percent : null;
  }

  ProductSearchLabelModel? get primaryLabel =>
      labels.isEmpty ? null : labels.first;
}
