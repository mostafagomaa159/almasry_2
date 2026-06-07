part of '../orders_imports.dart';

class OrderDetailsArgs {
  final int orderId;
  final String incrementId;

  const OrderDetailsArgs({
    required this.orderId,
    required this.incrementId,
  });
}
