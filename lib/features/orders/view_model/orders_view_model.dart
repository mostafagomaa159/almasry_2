part of '../orders_imports.dart';

/// Per-screen view model for [OrdersView].
class OrdersViewModel {
  /// Services

  final ApiService _apiService = sl<ApiService>();
  final NavigationService _nav = sl<NavigationService>();

  /// Variables

  final GenericCubit<List<OrderModel>> _ordersCubit =
      GenericCubit<List<OrderModel>>([]);

  int _page = 1;
  bool _isFetching = false;
  int? _totalItems;

  bool get canFetchMoreItems =>
      _totalItems == null ||
      _ordersCubit.state.data.length < (_totalItems ?? 0);

  /// Init

  Future<void> _init({required String email}) async {
    await _ordersApi(email);
  }

  void _dispose() {
    _ordersCubit.close();
  }

  /// Actions

  void _openOrderDetails(OrderModel order) {
    _nav.pushNamed(
      RouteNames.orderDetails,
      extra: OrderDetailsArgs(
        orderId: order.entityId,
        incrementId: order.incrementId,
      ),
    );
  }

  /// Pagination entry points, kept public: nothing calls them yet, but they are
  /// the intended API for a scroll listener / pull-to-refresh.
  Future<void> fetchMore({required String email}) async {
    await _ordersApi(email);
  }

  void reset() {
    _page = 1;
    _isFetching = false;
    _totalItems = null;
    _ordersCubit.onUpdateData([]);
  }

  /// Api

  Future<void> _ordersApi(String email) async {
    if (_isFetching || !canFetchMoreItems) return;

    _isFetching = true;

    try {
      final decodedEmail = Uri.decodeComponent(email);

      final request = OrdersModel(email: decodedEmail, currentPage: _page);

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

      _ordersCubit.onUpdateData([..._ordersCubit.state.data, ...list]);

      _page++;
    } catch (e) {
      debugPrint('Orders Error: $e');
    } finally {
      debugPrint('Orders fetched count: ${_ordersCubit.state.data.length}');
      _isFetching = false;
    }
  }
}
