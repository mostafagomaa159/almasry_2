import 'package:almasry_2/core/models/response/order/order_item_model.dart';
import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final int entityId;
  final String incrementId;
  final String createdAt;
  final String status;
  final String state;
  final double grandTotal;
  final double subtotal;
  final double shippingAmount;
  final int totalItemCount;
  final double totalQtyOrdered;
  final String shippingDescription;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.entityId,
    required this.incrementId,
    required this.createdAt,
    required this.status,
    required this.state,
    required this.grandTotal,
    required this.subtotal,
    required this.shippingAmount,
    required this.totalItemCount,
    required this.totalQtyOrdered,
    required this.shippingDescription,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];

    return OrderModel(
      entityId: int.tryParse(json['entity_id']?.toString() ?? '0') ?? 0,
      incrementId: json['increment_id']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      grandTotal: double.tryParse(json['grand_total']?.toString() ?? '0') ?? 0,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0,
      shippingAmount:
      double.tryParse(json['shipping_amount']?.toString() ?? '0') ?? 0,
      totalItemCount:
      int.tryParse(json['total_item_count']?.toString() ?? '0') ?? 0,
      totalQtyOrdered:
      double.tryParse(json['total_qty_ordered']?.toString() ?? '0') ?? 0,
      shippingDescription: json['shipping_description']?.toString() ?? '',
      items: itemsJson
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  OrderItemModel? get firstItem => items.isEmpty ? null : items.first;

  @override
  List<Object?> get props => [
    entityId,
    incrementId,
    createdAt,
    status,
    state,
    grandTotal,
    subtotal,
    shippingAmount,
    totalItemCount,
    totalQtyOrdered,
    shippingDescription,
    items,
  ];
}
