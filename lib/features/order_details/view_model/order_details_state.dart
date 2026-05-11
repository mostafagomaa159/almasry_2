import 'package:almasry_2/features/order_details/view_model/order_details_model.dart';

class OrderDetailsState {
  final bool isLoading;
  final OrderDetailsModel? orderDetails;

  const OrderDetailsState({
    this.isLoading = false,
    this.orderDetails,
  });

  OrderDetailsState copyWith({
    bool? isLoading,
    OrderDetailsModel? orderDetails,
  }) {
    return OrderDetailsState(
      isLoading: isLoading ?? this.isLoading,
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }
}
