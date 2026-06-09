part of '../my_order_imports.dart';
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final ApiService _apiService;

  OrderDetailsCubit(this._apiService) : super(const OrderDetailsState());

  String _extractApiMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return e.message ?? 'Something went wrong';
  }

  Future<void> loadOrderDetails({
    required String orderId,
  }) async {
    emit(
      state.copyWith(
        status: OrderDetailsStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await _apiService.get(
        endPoint: '${ApiConstants.orders}/$orderId',
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        emit(
          state.copyWith(
            status: OrderDetailsStatus.success,
            order: OrderModel.fromJson(data),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: OrderDetailsStatus.error,
          errorMessage: 'Invalid response format',
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: OrderDetailsStatus.error,
          errorMessage: _extractApiMessage(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderDetailsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
