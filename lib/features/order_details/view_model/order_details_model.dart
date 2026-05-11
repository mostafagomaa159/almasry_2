import 'package:almasry_2/features/orders/view_model/order_model.dart';

class OrderDetailsModel {
  final String orderId;
  final OrderStatus status;
  final String customerName;
  final String phoneNumber;
  final String address;
  final List<OrderItemModel> items;
  final double subtotal;
  final double shipping;
  final double discount;
  final double total;

  const OrderDetailsModel({
    required this.orderId,
    required this.status,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.total,
  });
}
