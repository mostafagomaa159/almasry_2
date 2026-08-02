import 'package:equatable/equatable.dart';

class OrderItemModel extends Equatable {
  final int itemId;
  final String name;
  final String sku;
  final double price;
  final double originalPrice;
  final double qtyOrdered;
  final double rowTotal;
  final String productImage;

  const OrderItemModel({
    required this.itemId,
    required this.name,
    required this.sku,
    required this.price,
    required this.originalPrice,
    required this.qtyOrdered,

    required this.rowTotal,
    required this.productImage,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final extensionAttributes =
        json['extension_attributes'] as Map<String, dynamic>? ?? {};

    return OrderItemModel(
      itemId: int.tryParse(json['item_id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      originalPrice:
          double.tryParse(json['original_price']?.toString() ?? '0') ?? 0,
      qtyOrdered: double.tryParse(json['qty_ordered']?.toString() ?? '0') ?? 0,
      rowTotal: double.tryParse(json['row_total']?.toString() ?? '0') ?? 0,
      productImage: extensionAttributes['product_image']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
    itemId,
    name,
    sku,
    price,
    originalPrice,
    qtyOrdered,
    rowTotal,
    productImage,
  ];
}
