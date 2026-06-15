part of '../my_order_imports.dart';

class OrderDetailsData extends Equatable {
  final bool isLoading;
  final OrderModel? order;
  final String? errorMessage;

  const OrderDetailsData({
    this.isLoading = false,
    this.order,
    this.errorMessage,
  });

  OrderDetailsData copyWith({
    bool? isLoading,
    OrderModel? order,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearOrder = false,
  }) {
    return OrderDetailsData(
      isLoading: isLoading ?? this.isLoading,
      order: clearOrder ? null : (order ?? this.order),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    order,
    errorMessage,
  ];
}
