part of '../../../../features/my_order_details/my_order_imports.dart';

class OrderDetailsModel extends Equatable {
  final bool isLoading;
  final OrderModel? order;
  final String? errorMessage;

  const OrderDetailsModel({
    this.isLoading = false,
    this.order,
    this.errorMessage,
  });

  OrderDetailsModel copyWith({
    bool? isLoading,
    OrderModel? order,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearOrder = false,
  }) {
    return OrderDetailsModel(
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
