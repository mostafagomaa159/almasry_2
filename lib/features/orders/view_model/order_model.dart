enum OrderStatus { delivered, pending }

class OrderModel {
  final String id;
  final OrderStatus status;
  final double total;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.status,
    required this.total,
    required this.items,
  });
}

class OrderItemModel {
  final String name;
  final String imagePath;
  final double price;

  const OrderItemModel({
    required this.name,
    required this.imagePath,
    required this.price,
  });
}
