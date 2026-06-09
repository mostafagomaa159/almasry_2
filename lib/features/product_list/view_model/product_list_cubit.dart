part of '../product_list_imports.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final ApiService _apiService;

  ProductListCubit(this._apiService) : super(const ProductListState());

  String _extractApiMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    if (data is Map) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return e.message ?? 'Something went wrong';
  }

  Future<ProductListPageModel> _fetchProducts(ProductListRequest request) async {
    final response = await _apiService.get(
      endPoint: request.endPoint,
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      final itemsJson = data['items'] as List<dynamic>? ?? [];
      final totalCount = (data['total_count'] as num?)?.toInt() ?? 0;

      final items = itemsJson
          .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList();

      return ProductListPageModel(items: items, totalCount: totalCount);
    }

    return const ProductListPageModel(items: [], totalCount: 0);
  }

  Future<void> loadInitialProducts({
    required String title,
    required String categoryId,
  }) async {
    emit(
      state.copyWith(
        status: ProductListStatus.loading,
        title: title,
        categoryId: categoryId,
        currentPage: 1,
        hasMore: true,
        isLoadingMore: false,
        totalCount: 0,
        clearErrorMessage: true,
        resetProducts: true,
      ),
    );

    try {
      final request = ProductListRequest(
        categoryId: categoryId,
        page: 1,
      );

      final result = await _fetchProducts(request);

      final hasMore = result.items.length < result.totalCount;

      emit(
        state.copyWith(
          status: ProductListStatus.success,
          products: result.items,
          currentPage: 1,
          totalCount: result.totalCount,
          hasMore: hasMore,
          isLoadingMore: false,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: ProductListStatus.error,
          errorMessage: _extractApiMessage(e),
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductListStatus.error,
          errorMessage: e.toString(),
          isLoadingMore: false,
        ),
      );
    }
  }

  int getProductQuantity(String sku) {
    return state.quantities[sku] ?? 1;
  }

  void incrementQuantity(String sku) {
    final updatedQuantities = Map<String, int>.from(state.quantities);
    final currentQuantity = updatedQuantities[sku] ?? 1;

    updatedQuantities[sku] = currentQuantity + 1;

    emit(state.copyWith(quantities: updatedQuantities));
  }

  void decrementQuantity(String sku) {
    final updatedQuantities = Map<String, int>.from(state.quantities);
    final currentQuantity = updatedQuantities[sku] ?? 1;

    if (currentQuantity > 1) {
      updatedQuantities[sku] = currentQuantity - 1;
      emit(state.copyWith(quantities: updatedQuantities));
    }
  }

  Future<void> loadMoreProducts() async {
    if (state.status != ProductListStatus.success) return;
    if (state.isLoadingMore) return;
    if (!state.hasMore) return;
    if (state.categoryId.isEmpty) return;

    emit(state.copyWith(isLoadingMore: true, clearErrorMessage: true));

    final nextPage = state.currentPage + 1;

    try {
      final request = ProductListRequest(
        categoryId: state.categoryId,
        page: nextPage,
      );

      final result = await _fetchProducts(request);

      final updatedProducts = [...state.products, ...result.items];

      final hasMore = updatedProducts.length < result.totalCount;

      emit(
        state.copyWith(
          status: ProductListStatus.success,
          products: updatedProducts,
          currentPage: nextPage,
          totalCount: result.totalCount,
          hasMore: hasMore,
          isLoadingMore: false,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: _extractApiMessage(e),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, errorMessage: e.toString()));
    }
  }
}
