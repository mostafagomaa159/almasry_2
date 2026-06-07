part of '../orders_imports.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final ApiService _apiService;

  OrdersCubit(this._apiService) : super(const OrdersState());

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

  Future<void> loadOrders({
    required String email,
  }) async {
    emit(
      state.copyWith(
        status: OrdersStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final endPoint =
          '${ApiConstants.orders}'
          '?searchCriteria[filter_groups][0][filters][0][field]=customer_email'
          '&searchCriteria[filter_groups][0][filters][0][value]=$email'
          '&searchCriteria[filter_groups][0][filters][0][condition_type]=eq'
          '&searchCriteria[pageSize]=20'
          '&searchCriteria[currentPage]=1'
          '&searchCriteria[sortOrders][0][field]=created_at'
          '&searchCriteria[sortOrders][0][direction]=DESC';

      final response = await _apiService.get(endPoint: endPoint);

      final data = response.data;

      if (data is Map<String, dynamic> && data['items'] is List) {
        final items = data['items'] as List<dynamic>;

        final orders = items
            .map((e) => OrderResponse.fromJson(e as Map<String, dynamic>))
            .toList();

        emit(
          state.copyWith(
            status: OrdersStatus.success,
            orders: orders,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: OrdersStatus.success,
          orders: const [],
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: OrdersStatus.error,
          errorMessage: _extractApiMessage(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrdersStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
