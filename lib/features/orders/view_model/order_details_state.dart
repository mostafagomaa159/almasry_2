part of '../orders_imports.dart';
enum OrderDetailsStatus {
  initial,
  loading,
  success,
  error,
}

class OrderDetailsState extends Equatable {
  final OrderDetailsStatus status;
  final OrderModel? order;
  final String errorMessage;

  const OrderDetailsState({
    this.status = OrderDetailsStatus.initial,
    this.order,
    this.errorMessage = '',
  });

  OrderDetailsState copyWith({
    OrderDetailsStatus? status,
    OrderModel? order,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return OrderDetailsState(
      status: status ?? this.status,
      order: order ?? this.order,
      errorMessage: clearErrorMessage ? '' : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    order,
    errorMessage,
  ];
}

