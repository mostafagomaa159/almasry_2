
class ProductExtensionAttributesModel {
  final String urlBase;
  final String thumbnail;
  final num priceAfter;
  final num priceBefore;
  final String stockStatus;
  final String sellableQuantity;
  final String description;

  const ProductExtensionAttributesModel({
    required this.urlBase,
    required this.thumbnail,
    required this.priceAfter,
    required this.priceBefore,
    required this.stockStatus,
    required this.sellableQuantity,
    required this.description,
  });

  factory ProductExtensionAttributesModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProductExtensionAttributesModel(
      urlBase: json['url_base']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      priceAfter: (json['price_after'] as num?) ?? 0,
      priceBefore: (json['price_before'] as num?) ?? 0,
      stockStatus: json['stock_status']?.toString() ?? '',
      sellableQuantity: json['sellable_quantity']?.toString() ?? '0',
      description: json['description']?.toString() ?? '',
    );
  }
}
