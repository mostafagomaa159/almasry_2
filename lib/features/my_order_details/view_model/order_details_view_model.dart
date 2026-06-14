part of '../my_order_imports.dart';

class OrderDetailsViewModel {
  /// Services
  final ApiService _apiService = sl<ApiService>();

  /// Cubit
  final GenericCubit<OrderDetailsData> orderDetailsCubit =
  GenericCubit<OrderDetailsData>(const OrderDetailsData());

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

  Future<void> init({required String orderId}) async {
    await loadOrderDetails(orderId: orderId);
  }

  Future<void> loadOrderDetails({
    required String orderId,
  }) async {
    final current = orderDetailsCubit.state.data;

    orderDetailsCubit.onUpdateData(
      current.copyWith(
        isLoading: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await _apiService.get(
        endPoint: '${ApiConstants.orders}/$orderId',
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        orderDetailsCubit.onUpdateData(
          orderDetailsCubit.state.data.copyWith(
            isLoading: false,
            order: OrderModel.fromJson(data),
            clearErrorMessage: true,
          ),
        );
        return;
      }

      orderDetailsCubit.onUpdateData(
        orderDetailsCubit.state.data.copyWith(
          isLoading: false,
          errorMessage: 'Invalid response format',
        ),
      );
    } on DioException catch (e) {
      orderDetailsCubit.onUpdateData(
        orderDetailsCubit.state.data.copyWith(
          isLoading: false,
          errorMessage: _extractApiMessage(e),
        ),
      );
    } catch (e) {
      orderDetailsCubit.onUpdateData(
        orderDetailsCubit.state.data.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }


}
