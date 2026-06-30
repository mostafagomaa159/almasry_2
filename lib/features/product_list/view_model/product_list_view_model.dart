part of '../product_list_imports.dart';

class ProductListViewModel {
  /// Services
  final ApiService _apiService = sl<ApiService>();

  /// Cubit
  final GenericCubit<ProductListData> productListCubit =
      GenericCubit<ProductListData>(const ProductListData.ProductListModel());

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

  Future<ProductListModel> _fetchProducts(ProductListRequest request) async {
    final response = await _apiService.get(endPoint: request.endPoint);

    final data = response.data;

    if (data is Map<String, dynamic>) {
      final itemsJson = data['items'] as List<dynamic>? ?? [];
      final totalCount = (data['total_count'] as num?)?.toInt() ?? 0;

      final items = itemsJson
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return ProductListModel(items: items, totalCount: totalCount);
    }

    return const ProductListModel(items: [], totalCount: 0);
  }

  Future<void> init({required String title, required String categoryId}) async {
    await loadInitialProducts(title: title, categoryId: categoryId);
  }

  Future<void> loadInitialProducts({
    required String title,
    required String categoryId,
  }) async {
    final current = productListCubit.state.data;

    productListCubit.onUpdateData(
      current.copyWith(
        status: ProductListStatus.loading,
        title: title,
        categoryId: categoryId,
        currentPage: 1,
        hasMore: true,
        isLoadingMore: false,
        totalCount: 0,
        clearErrorMessage: true,
        resetProducts: true,
        resetQuantities: true,
      ),
    );

    try {
      final request = ProductListRequest(categoryId: categoryId, page: 1);

      final result = await _fetchProducts(request);

      final hasMore = result.items.length < result.totalCount;

      productListCubit.onUpdateData(
        productListCubit.state.data.copyWith(
          status: ProductListStatus.success,
          products: result.items,
          currentPage: 1,
          totalCount: result.totalCount,
          hasMore: hasMore,
          isLoadingMore: false,
        ),
      );
    } on DioException catch (e) {
      productListCubit.onUpdateData(
        productListCubit.state.data.copyWith(
          status: ProductListStatus.error,
          errorMessage: _extractApiMessage(e),
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      productListCubit.onUpdateData(
        productListCubit.state.data.copyWith(
          status: ProductListStatus.error,
          errorMessage: e.toString(),
          isLoadingMore: false,
        ),
      );
    }
  }

  int getProductQuantity(String sku) {
    return productListCubit.state.data.quantities[sku] ?? 1;
  }

  void incrementQuantity(String sku) {
    final current = productListCubit.state.data;
    final updatedQuantities = Map<String, int>.from(current.quantities);
    final currentQuantity = updatedQuantities[sku] ?? 1;

    updatedQuantities[sku] = currentQuantity + 1;

    productListCubit.onUpdateData(
      current.copyWith(quantities: updatedQuantities),
    );
  }

  void decrementQuantity(String sku) {
    final current = productListCubit.state.data;
    final updatedQuantities = Map<String, int>.from(current.quantities);
    final currentQuantity = updatedQuantities[sku] ?? 1;

    if (currentQuantity > 1) {
      updatedQuantities[sku] = currentQuantity - 1;

      productListCubit.onUpdateData(
        current.copyWith(quantities: updatedQuantities),
      );
    }
  }

  Future<void> loadMoreProducts() async {
    final current = productListCubit.state.data;

    if (current.status != ProductListStatus.success) return;
    if (current.isLoadingMore) return;
    if (!current.hasMore) return;
    if (current.categoryId.isEmpty) return;

    productListCubit.onUpdateData(
      current.copyWith(isLoadingMore: true, clearErrorMessage: true),
    );

    final nextPage = current.currentPage + 1;

    try {
      final request = ProductListRequest(
        categoryId: current.categoryId,
        page: nextPage,
      );

      final result = await _fetchProducts(request);

      final updatedProducts = [...current.products, ...result.items];
      final hasMore = updatedProducts.length < result.totalCount;

      productListCubit.onUpdateData(
        productListCubit.state.data.copyWith(
          status: ProductListStatus.success,
          products: updatedProducts,
          currentPage: nextPage,
          totalCount: result.totalCount,
          hasMore: hasMore,
          isLoadingMore: false,
        ),
      );
    } on DioException catch (e) {
      productListCubit.onUpdateData(
        productListCubit.state.data.copyWith(
          isLoadingMore: false,
          errorMessage: _extractApiMessage(e),
        ),
      );
    } catch (e) {
      productListCubit.onUpdateData(
        productListCubit.state.data.copyWith(
          isLoadingMore: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void navToProductDetails(BuildContext context, ProductModel product) {
    final sku = product.sku ?? '';
    if (sku.isEmpty) return;

    context.pushNamed(
      'productDetails',
      extra: ProductDetailsArgs(
        sku: sku,
        title: product.name,
        imagePath: product.extensionAttributes?.thumbnail,
      ),
    );

  }
}
