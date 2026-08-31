part of '../product_list_imports.dart';

class ProductListViewModel {
  final _apiService = sl<ApiService>();
  final _navService = sl<NavigationService>();
  final _cartService = sl<CartService>();
  final _alertService = sl<AlertService>();
  final _favoritesService = sl<FavoritesService>();

  final GenericCubit<List<ProductModel>?> _productsCubit =
      GenericCubit<List<ProductModel>?>(null);

  late final ScrollController _scrollController;

  String _errorMessage = '';
  bool _isLoadingMore = false;
  Map<String, int> _quantities = const {};

  String _title = '';
  String _categoryId = '';
  bool _isBrand = false;
  int _currentPage = 1;
  bool _hasMore = true;

  List<ProductModel> _loadedProducts() => _productsCubit.state.data ?? const [];

  late final GenericCubit<Set<String>> _addingSkusCubit =
      _cartService.addingSkusCubit;

  late final GenericCubit<ListFavorites> _favoritesCubit =
      _favoritesService.favoritesCubit;

  Future<void> _init({
    required String title,
    required String categoryId,
    bool isBrand = false,
  }) async {
    _title = title;
    _categoryId = categoryId;
    _isBrand = isBrand;

    _scrollController = ScrollController()..addListener(_onScroll);

    await Future.wait([
      _favoritesService.loadFavorites(),
      _loadInitialProducts(),
    ]);
  }

  void _dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
  }

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

  void _incrementQuantity(String sku) {
    final Map<String, int> updated = Map<String, int>.from(_quantities);

    updated[sku] = (updated[sku] ?? 1) + 1;
    _quantities = updated;

    _productsCubit.onUpdateData(_loadedProducts());
  }

  void _decrementQuantity(String sku) {
    final int currentQuantity = _quantities[sku] ?? 1;
    if (currentQuantity <= 1) return;

    final Map<String, int> updated = Map<String, int>.from(_quantities);

    updated[sku] = currentQuantity - 1;
    _quantities = updated;

    _productsCubit.onUpdateData(_loadedProducts());
  }

  Future<void> _addToCart(String sku) async {
    if (sku.trim().isEmpty) return;

    final int quantity = _getProductQuantity(sku);

    if (await _cartService.addToCart(sku: sku, quantity: quantity)) {
      _alertService.showSuccess(LocaleKeys.cartAddedSuccess.tr());

      return;
    }

    final String message = _cartService.errorMessage;

    if (message.trim().isEmpty) return;

    _alertService.showError(message);
  }

  Future<void> _toggleFavorite(FavoriteProductModel product) async {
    await _favoritesService.toggleFavorite(product);
  }

  void _goBack() {
    _navService.pop();
  }

  void _navToProductDetails(ProductModel product) {
    final String sku = product.sku;
    if (sku.isEmpty) return;

    _navService.pushNamed(
      RouteNames.productDetails,
      extra: ProductDetailsArgs(
        sku: sku,
        title: product.name,
        imagePath: product.extensionAttributes?.thumbnail,
      ),
    );
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

  Future<void> _loadInitialProducts() async {
    _currentPage = 1;
    _hasMore = true;
    _errorMessage = '';
    _isLoadingMore = false;
    _quantities = const {};

    _productsCubit.onUpdateData(null);

    try {
      final request = ProductListRequest(
        categoryId: _categoryId,
        page: 1,
        isBrand: _isBrand,
      );

      final ProductListModel result = await _fetchProducts(request);

      _hasMore = result.items.length < result.totalCount;

      _productsCubit.onUpdateData(result.items);
    } catch (error) {
      _errorMessage = errorMessageFrom(error);

      _productsCubit.onUpdateData(const []);
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;
    if (_productsCubit.state.data == null) return;
    if (_categoryId.isEmpty) return;

    _isLoadingMore = true;

    _productsCubit.onUpdateData(_loadedProducts());

    final int nextPage = _currentPage + 1;

    try {
      final request = ProductListRequest(
        categoryId: _categoryId,
        page: nextPage,
        isBrand: _isBrand,
      );

      final ProductListModel result = await _fetchProducts(request);

      final List<ProductModel> updatedProducts = [
        ..._loadedProducts(),
        ...result.items,
      ];

      _currentPage = nextPage;
      _hasMore = updatedProducts.length < result.totalCount;
      _isLoadingMore = false;

      _productsCubit.onUpdateData(updatedProducts);
    } catch (_) {
      _isLoadingMore = false;

      _productsCubit.onUpdateData(_loadedProducts());
    }
  }
}
