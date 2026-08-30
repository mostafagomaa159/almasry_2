part of '../my_order_imports.dart';

class OrderDetailsViewModel {
  /// Services

  final ApiService _apiService = sl<ApiService>();

  /// Variables

  final GenericCubit<OrderDetailsModel> _orderDetailsCubit =
      GenericCubit<OrderDetailsModel>(const OrderDetailsModel());

  OrderDetailsModel _data() => _orderDetailsCubit.state.data;

  /// Init

  Future<void> _init({required String orderId}) async {
    await _loadOrderDetails(orderId: orderId);
  }

  void _dispose() {
    _orderDetailsCubit.close();
  }

  /// Api

  Future<void> _loadOrderDetails({required String orderId}) async {
    final current = _orderDetailsCubit.state.data;

    _orderDetailsCubit.onUpdateData(
      current.copyWith(isLoading: true, clearErrorMessage: true),
    );

    try {
      final response = await _apiService.get(
        endPoint: '${ApiConstants.orders}/$orderId',
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        _orderDetailsCubit.onUpdateData(
          _orderDetailsCubit.state.data.copyWith(
            isLoading: false,
            order: OrderModel.fromJson(data),
            clearErrorMessage: true,
          ),
        );
        return;
      }

      _orderDetailsCubit.onUpdateData(
        _orderDetailsCubit.state.data.copyWith(
          isLoading: false,
          errorMessage: LocaleKeys.invalidResponseFormat.tr(),
        ),
      );
    } catch (error) {
      _orderDetailsCubit.onUpdateData(
        _orderDetailsCubit.state.data.copyWith(
          isLoading: false,
          errorMessage: errorMessageFrom(error),
        ),
      );
    }
  }
}
