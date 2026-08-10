part of '../product_list_imports.dart';

class ProductListViewModel {
  /// Services

  final ApiService _apiService = sl<ApiService>();
  final NavigationService _nav = sl<NavigationService>();

  /// Variables

  /// The screen's only cubit. `null` means the first page is still loading;
  /// a list — empty or not — means it has arrived.
  final GenericCubit<List<ProductModel>?> _productsCubit =
      GenericCubit<List<ProductModel>?>(null);

  late final ScrollController _scrollController;

  /// Plain fields, not cubits. Each one is written before the cubit emits, so
  /// the rebuild that emit triggers always reads the matching value.
  String _errorMessage = '';
  bool _isLoadingMore = false;
  Map<String, int> _quantities = const {};

  /// Paging bookkeeping — nothing renders it.
  String _title = '';
  String _categoryId = '';
  int _currentPage = 1;
  bool _hasMore = true;

  List<ProductModel> get _loadedProducts =>
      _productsCubit.state.data ?? const [];

  /// Init

  Future<void> _init({
    required String title,
    required String categoryId,
  }) async {
    _title = title;
    _categoryId = categoryId;

    _scrollController = ScrollController()..addListener(_onScroll);

    await _loadInitialProducts();
  }

  void _dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    _productsCubit.close();
  }

  /// Actions

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final double currentOffset = _scrollController.position.pixels;
    final double maxOffset = _scrollController.position.maxScrollExtent;

    if (currentOffset >= maxOffset - 200) {
      _loadMoreProducts();
    }
  }

  int _getProductQuantity(String sku) {
    return _quantities[sku] ?? 1;
  }

  /// Re-emits the same list to get a rebuild — `GenericState.changed` makes
  /// that work.
  void _incrementQuantity(String sku) {
    final Map<String, int> updated = Map<String, int>.from(_quantities);

    updated[sku] = (updated[sku] ?? 1) + 1;
    _quantities = updated;

    _productsCubit.onUpdateData(_loadedProducts);
  }

  void _decrementQuantity(String sku) {
    final int currentQuantity = _quantities[sku] ?? 1;
    if (currentQuantity <= 1) return;

    final Map<String, int> updated = Map<String, int>.from(_quantities);

    updated[sku] = currentQuantity - 1;
    _quantities = updated;

    _productsCubit.onUpdateData(_loadedProducts);
  }

  void _goBack() {
    _nav.pop();
  }

  void _navToProductDetails(ProductModel product) {
    final String sku = product.sku;
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

  Future<void> _loadInitialProducts() async {
    _currentPage = 1;
    _hasMore = true;
    _errorMessage = '';
    _isLoadingMore = false;
    _quantities = const {};

    /// Back to `null` so the spinner replaces whatever was on screen.
    _productsCubit.onUpdateData(null);

    try {
      final request = ProductListRequest(categoryId: _categoryId, page: 1);

      final ProductListModel result = await _fetchProducts(request);

      _hasMore = result.items.length < result.totalCount;

      _productsCubit.onUpdateData(result.items);
    } catch (error) {
      _errorMessage = errorMessageFrom(error);

      /// Empty list + a message is what the body reads as "error".
      _productsCubit.onUpdateData(const []);
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;
    if (_productsCubit.state.data == null) return;
    if (_categoryId.isEmpty) return;

    _isLoadingMore = true;

    /// Same list, but the emit still forces the trailing spinner in.
    _productsCubit.onUpdateData(_loadedProducts);

    final int nextPage = _currentPage + 1;

    try {
      final request = ProductListRequest(
        categoryId: _categoryId,
        page: nextPage,
      );

      final ProductListModel result = await _fetchProducts(request);

      final List<ProductModel> updatedProducts = [
        ..._loadedProducts,
        ...result.items,
      ];

      _currentPage = nextPage;
      _hasMore = updatedProducts.length < result.totalCount;
      _isLoadingMore = false;

      _productsCubit.onUpdateData(updatedProducts);
    } catch (_) {
      /// A failed "load more" keeps the pages already on screen.
      _isLoadingMore = false;

      _productsCubit.onUpdateData(_loadedProducts);
    }
  }
}
