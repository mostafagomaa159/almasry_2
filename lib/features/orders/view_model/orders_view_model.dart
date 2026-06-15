part of '../orders_imports.dart';

class OrdersViewModel {
  /// Services
  final ApiService _apiService = sl<ApiService>();

  /// Cubit
  final GenericCubit<List<OrderModel>>
  ordersCubit =
  GenericCubit<List<OrderModel>>([]);

  int _page = 1;
  bool _isFetching = false;
  int? _totalItems;

  bool get canFetchMoreItems =>
      _totalItems == null || ordersCubit.state.data.length < (_totalItems ?? 0);

  /// Init
  Future<void> init({required String email}) async {
    await getOrders(email: email);
  }

  /// Public API
  Future<void> getOrders({required String email}) async {
    await _ordersApi(email);
  }

  Future<void> fetchMore({required String email}) async {
    await _ordersApi(email);
  }

  void reset() {
    _page = 1;
    _isFetching = false;
    _totalItems = null;
    ordersCubit.onUpdateData([]);
  }

  /// Api Methods
  Future<void> _ordersApi(String email) async {
    if (_isFetching || !canFetchMoreItems) return;

    _isFetching = true;

    try {
      final decodedEmail = Uri.decodeComponent(email);

      final request = OrdersModel(
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

      final list = items.map(OrderModel.fromJson).toList();

      if (data is Map<String, dynamic>) {
        _totalItems = int.tryParse(data['total_count']?.toString() ?? '') ?? 0;
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

}
