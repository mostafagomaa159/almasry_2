part of '../orders_imports.dart';

class OrdersViewModel {
  OrdersViewModel(this._apiService);

  /// Init
  Future<void> init({
    required String email,
  }) async {
    await loadInitialOrders(email: email);
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
  Future<void> loadInitialOrders({
    required String email,
  }) async {
    _page = 1;
    _totalItems = null;
    ordersCubit.reset([]);

    await _loadOrders(
      email: email,
      isInitialLoad: true,
    );
  }

  Future<void> refreshOrders({
    required String email,
  }) async {
    await loadInitialOrders(email: email);
  }

  Future<void> loadMoreOrders({
    required String email,
  }) async {
    await _loadOrders(
      email: email,
      isInitialLoad: false,
    );
  }

  Future<void> _loadOrders({
    required String email,
    required bool isInitialLoad,
  }) async {
    if (_isFetching || (!canFetchMoreItems && !isInitialLoad)) return;

    _isFetching = true;

    try {
      final decodedEmail = Uri.decodeComponent(email);

      final request = OrdersRequest(
        email: decodedEmail,
        currentPage: _page,
      );

      final response = await _apiService.get(
        endPoint: request.endPoint,
        queryParameters: request.queryParameters,
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        final items = List<Map<String, dynamic>>.from(data['items'] ?? []);

        final fetchedOrders = items
            .map(OrderResponse.fromJson)
            .toList();

        _totalItems =
            int.tryParse(data['total_count']?.toString() ?? '') ??
                fetchedOrders.length;

        if (isInitialLoad) {
          ordersCubit.update(fetchedOrders);
        } else {
          ordersCubit.update([
            ...ordersCubit.state.data,
            ...fetchedOrders,
          ]);
        }

        if (fetchedOrders.isNotEmpty) {
          _page++;
        }
      } else {
        if (isInitialLoad) {
          ordersCubit.update([]);
        }
      }
    } on DioException catch (e) {
      debugPrint('Orders DioException: ${_extractApiMessage(e)}');

      if (isInitialLoad) {
        ordersCubit.update([]);
      }
    } catch (e) {
      debugPrint('Orders Error: $e');

      if (isInitialLoad) {
        ordersCubit.update([]);
      }
    } finally {
      debugPrint('Orders fetched count: ${ordersCubit.state.data.length}');
      _isFetching = false;
    }
  }

  /// Helpers
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

  /// Dispose
  void dispose() {
    ordersCubit.close();
  }
}
