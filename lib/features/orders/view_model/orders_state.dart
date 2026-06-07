part of '../orders_imports.dart';

enum OrdersStatus {
  initial,
  loading,
  success,
  error,
}

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<OrderResponse> orders;
  final String errorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.errorMessage = '',
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderResponse>? orders,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: clearErrorMessage ? '' : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    orders,
    errorMessage,
  ];
}
