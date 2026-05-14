part of '../orders_imports.dart';


class OrdersState {
  final List<OrderModel> orders;
  final bool isLoading;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
  });

  OrdersState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
