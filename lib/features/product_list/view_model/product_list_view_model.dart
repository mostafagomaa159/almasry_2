part of '../product_list_imports.dart';

class ProductListViewModel {
  /// Services

  final ApiService _apiService = sl<ApiService>();
  final NavigationService _nav = sl<NavigationService>();

  /// Variables

  final GenericCubit<ProductListData> _productListCubit =
      GenericCubit<ProductListData>(const ProductListData.ProductListModel());

  late final ScrollController _scrollController;

  String _title = '';

  ProductListData get _data => _productListCubit.state.data;

  /// Init

  Future<void> _init({
    required String title,
    required String categoryId,
  }) async {
    _title = title;

    _scrollController = ScrollController()..addListener(_onScroll);

    await _loadInitialProducts(title: title, categoryId: categoryId);
  }

  void _dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _productListCubit.close();
  }

  /// Form state

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final currentOffset = _scrollController.position.pixels;
    final maxOffset = _scrollController.position.maxScrollExtent;

    if (currentOffset >= maxOffset - 200) {
      _loadMoreProducts();
    }
  }

  int _getProductQuantity(String sku) {
    return _productListCubit.state.data.quantities[sku] ?? 1;
  }

  void _incrementQuantity(String sku) {
    final current = _productListCubit.state.data;
    final updatedQuantities = Map<String, int>.from(current.quantities);
    final currentQuantity = updatedQuantities[sku] ?? 1;

    updatedQuantities[sku] = currentQuantity + 1;

    _productListCubit.onUpdateData(
      current.copyWith(quantities: updatedQuantities),
    );
  }

  void _decrementQuantity(String sku) {
    final current = _productListCubit.state.data;
    final updatedQuantities = Map<String, int>.from(current.quantities);
    final currentQuantity = updatedQuantities[sku] ?? 1;

    if (currentQuantity > 1) {
      updatedQuantities[sku] = currentQuantity - 1;

      _productListCubit.onUpdateData(
        current.copyWith(quantities: updatedQuantities),
      );
    }
  }

  /// Actions

  void _goBack() {
    _nav.pop();
  }

  void _navToProductDetails(ProductModel product) {
    final sku = product.sku ?? '';
    if (sku.isEmpty) return;

    _nav.pushNamed(
      RouteNames.productDetails,
      extra: ProductDetailsArgs(
        sku: sku,
        title: product.name,
        imagePath: product.extensionAttributes?.thumbnail,
      ),
    );
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

    if (data is Map) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return e.message ?? LocaleKeys.somethingWentWrong.tr();
  }

  /// Api

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

  Future<void> _loadInitialProducts({
    required String title,
    required String categoryId,
  }) async {
    final current = _productListCubit.state.data;

    _productListCubit.onUpdateData(
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

      _productListCubit.onUpdateData(
        _productListCubit.state.data.copyWith(
          status: ProductListStatus.success,
          products: result.items,
          currentPage: 1,
          totalCount: result.totalCount,
          hasMore: hasMore,
          isLoadingMore: false,
        ),
      );
    } on DioException catch (e) {
      _productListCubit.onUpdateData(
        _productListCubit.state.data.copyWith(
          status: ProductListStatus.error,
          errorMessage: _extractApiMessage(e),
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      _productListCubit.onUpdateData(
        _productListCubit.state.data.copyWith(
          status: ProductListStatus.error,
          errorMessage: e.toString(),
          isLoadingMore: false,
        ),
      );
    }
  }

  Future<void> _loadMoreProducts() async {
    final current = _productListCubit.state.data;

    if (current.status != ProductListStatus.success) return;
    if (current.isLoadingMore) return;
    if (!current.hasMore) return;
    if (current.categoryId.isEmpty) return;

    _productListCubit.onUpdateData(
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

      _productListCubit.onUpdateData(
        _productListCubit.state.data.copyWith(
          status: ProductListStatus.success,
          products: updatedProducts,
          currentPage: nextPage,
          totalCount: result.totalCount,
          hasMore: hasMore,
          isLoadingMore: false,
        ),
      );
    } on DioException catch (e) {
      _productListCubit.onUpdateData(
        _productListCubit.state.data.copyWith(
          isLoadingMore: false,
          errorMessage: _extractApiMessage(e),
        ),
      );
    } catch (e) {
      _productListCubit.onUpdateData(
        _productListCubit.state.data.copyWith(
          isLoadingMore: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
