part of '../orders_imports.dart';


class OrdersViewModel {
  final ApiService _apiService;

  OrdersViewModel(this._apiService);

  final GenericCubit<List<OrderResponse>> ordersCubit =
  GenericCubit<List<OrderResponse>>([]);

  bool isLoading = false;
  String errorMessage = '';

  int _page = 1;
  bool _isFetching = false;
  int? _totalItems;

  bool get canFetchMoreItems =>
      _totalItems == null || ordersCubit.state.data.length < (_totalItems ?? 0);

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

  Future<void> loadInitialOrders({
    required String email,
    required VoidCallback onStateChanged,
  }) async {
    _page = 1;
    _totalItems = null;
    errorMessage = '';
    isLoading = true;
    ordersCubit.reset([]);

    onStateChanged();

    await _loadOrders(
      email: email,
      onStateChanged: onStateChanged,
      isInitialLoad: true,
    );
  }

  Future<void> loadMoreOrders({
    required String email,
    required VoidCallback onStateChanged,
  }) async {
    await _loadOrders(
      email: email,
      onStateChanged: onStateChanged,
      isInitialLoad: false,
    );
  }

  Future<void> refreshOrders({
    required String email,
    required VoidCallback onStateChanged,
  }) async {
    await loadInitialOrders(
      email: email,
      onStateChanged: onStateChanged,
    );
  }

  Future<void> _loadOrders({
    required String email,
    required VoidCallback onStateChanged,
    required bool isInitialLoad,
  }) async {
    if (_isFetching || !canFetchMoreItems && !isInitialLoad) return;

    _isFetching = true;

    if (!isInitialLoad) {
      errorMessage = '';
      onStateChanged();
    }

    try {
      final request = OrdersRequest(
        email: email,
        currentPage: _page,
      );

      final response = await _apiService.get(
        endPoint: request.endPoint,
        queryParameters: request.queryParameters,
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        final items = (data['items'] as List<dynamic>? ?? []);

        final fetchedOrders = items
            .map((e) => OrderResponse.fromJson(e as Map<String, dynamic>))
            .toList();

        _totalItems = int.tryParse(data['total_count']?.toString() ?? '') ??
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

        errorMessage = '';
      } else {
        if (isInitialLoad) {
          ordersCubit.reset([]);
        }
        errorMessage = '';
      }
    } on DioException catch (e) {
      errorMessage = _extractApiMessage(e);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      _isFetching = false;
      onStateChanged();

      debugPrint(
        'Orders fetched count: ${ordersCubit.state.data.length}',
      );
    }
  }

  void dispose() {
    ordersCubit.close();
  }
}
