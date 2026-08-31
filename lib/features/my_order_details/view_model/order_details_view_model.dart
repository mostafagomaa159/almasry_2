part of '../my_order_imports.dart';

class OrderDetailsViewModel {
  final _apiService = sl<ApiService>();

  final GenericCubit<OrderModel?> _orderCubit = GenericCubit<OrderModel?>(null);

  final GenericCubit<bool> _loadingCubit = GenericCubit<bool>(false);

  String _errorMessage = '';

  OrderModel? _order() => _orderCubit.state.data;

  Future<void> _init({required String orderId}) async {
    await _loadOrderDetails(orderId: orderId);
  }

  void _dispose() {
    _orderCubit.close();
    _loadingCubit.close();
  }

  Future<void> _loadOrderDetails({required String orderId}) async {
    _errorMessage = '';

    _loadingCubit.onUpdateData(true);

    try {
      final response = await _apiService.get(
        endPoint: '${ApiConstants.orders}/$orderId',
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        _orderCubit.onUpdateData(OrderModel.fromJson(data));

        return;
      }

      _fail(LocaleKeys.invalidResponseFormat.tr());
    } catch (error) {
      _fail(errorMessageFrom(error));
    } finally {
      _loadingCubit.onUpdateData(false);
    }
  }

  void _fail(String message) {
    _errorMessage = message;

    _orderCubit.onUpdateData(_order());
  }
}
