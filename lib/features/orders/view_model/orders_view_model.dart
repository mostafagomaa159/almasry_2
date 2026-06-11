part of '../orders_imports.dart';

class OrdersViewModel {
  OrdersViewModel(this._apiService);

  /// Init
  Future<void> init({
    required String email,
  }) async {
    await _ordersApi(email);
  }

  /// Services
  final ApiService _apiService;

  /// Get Orders
  final GenericCubit<List<OrderResponse>> ordersCubit =
  GenericCubit<List<OrderResponse>>([]);

  int _page = 1;
  bool _isFetching = false;
  int? _totalItems;

  bool get canFetchMoreItems =>
      _totalItems == null ||
          ordersCubit.state.data.length < (_totalItems ?? 0);

  /// Api Methods
  Future<void> _ordersApi(String email) async {
    if (_isFetching || !canFetchMoreItems) return;

    _isFetching = true;

    try {
      final decodedEmail = Uri.decodeComponent(email);

      final request = OrdersRequest(
        email: decodedEmail,
        currentPage: _page,
      );

      final response = await _apiService.get(
        endPoint: request.endPoint,
        queryParameters: request.toJson(),
      );


      final data = response.data;

      final items = List<Map<String, dynamic>>.from(
        (data is Map<String, dynamic>) ? (data['items'] ?? []) : [],
      );

      final list = items.map(OrderResponse.fromJson).toList();

      if (data is Map<String, dynamic>) {
        _totalItems =
            int.tryParse(data['total_count']?.toString() ?? '') ?? 0;
      }

      ordersCubit.onUpdateData([
        ...ordersCubit.state.data,
        ...list,
      ]);

      _page++;
    } catch (e) {
      debugPrint('Orders Error: $e');
    } finally {
      debugPrint('Orders fetched count: ${ordersCubit.state.data.length}');
      _isFetching = false;
    }
  }

  /// Dispose
  void dispose() {
    ordersCubit.close();
  }
}
