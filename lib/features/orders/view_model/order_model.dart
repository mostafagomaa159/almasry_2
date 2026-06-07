enum OrderStatus {
  pending,
  delivered,
  processing,
  canceled,
  unknown,
}

OrderStatus parseOrderStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'pending':
      return OrderStatus.pending;
    case 'complete':
    case 'delivered':
      return OrderStatus.delivered;
    case 'processing':
      return OrderStatus.processing;
    case 'canceled':
    case 'cancelled':
      return OrderStatus.canceled;
    default:
      return OrderStatus.unknown;
  }
}

class OrderModel {
  final String id;
  final String incrementId;
  final OrderStatus status;
  final double total;
  final String createdAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.incrementId,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['entity_id']?.toString() ?? '',
      incrementId: json['increment_id']?.toString() ?? '',
      status: parseOrderStatus(json['status']?.toString()),
      total: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at']?.toString() ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderItemModel {
  final String name;
  final String imagePath;
  final double price;
  final int qtyOrdered;
  final String sku;

  const OrderItemModel({
    required this.name,
    required this.imagePath,
    required this.price,
    required this.qtyOrdered,
    required this.sku,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name']?.toString() ?? '',
      imagePath:
      json['extension_attributes']?['product_image']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      qtyOrdered: (json['qty_ordered'] as num?)?.toInt() ?? 0,
      sku: json['sku']?.toString() ?? '',
    );
  }
}
