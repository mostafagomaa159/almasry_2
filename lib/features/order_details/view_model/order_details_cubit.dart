part of '../order_details_imports.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit() : super(const OrderDetailsState());

  void loadOrderDetails(String orderId) {
    emit(state.copyWith(isLoading: true));

    emit(
      state.copyWith(
        isLoading: false,
        orderDetails: OrderDetailsModel(
          orderId: orderId,
          status: OrderStatus.delivered,
          customerName: 'محمد هاني احمد',
          phoneNumber: '68695443320',
          address: '12 - شارع احمد عرابي - وسط المدينة - القاهرة',
          items: const [
            OrderItemModel(
              name: 'سويبل أمبولات للشعر فيتامين',
              imagePath: 'assets/images/order_product.png',
              price: 245.00,
            ),
            OrderItemModel(
              name: 'سويبل أمبولات للشعر فيتامين',
              imagePath: 'assets/images/order_product.png',
              price: 245.00,
            ),
          ],
          subtotal: 245.00,
          shipping: 0.00,
          discount: 0.00,
          total: 245.00,
        ),
      ),
    );
  }
}
