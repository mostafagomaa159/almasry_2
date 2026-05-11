
import 'package:almasry_2/features/orders/view_model/order_model.dart';
import 'package:almasry_2/features/orders/view_model/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersState());

  void loadOrders() {
    emit(
      state.copyWith(
        orders: const [
          OrderModel(
            id: '957940',
            status: OrderStatus.delivered,
            total: 245.00,
            items: [
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
          ),
          OrderModel(
            id: '957941',
            status: OrderStatus.delivered,
            total: 245.00,
            items: [
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
          ),
        ],
      ),
    );
  }
}
