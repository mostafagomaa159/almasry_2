part of '../product_search_imports.dart';

typedef ListSearchProducts = List<ProductSearchProductModel>;

class ProductSearchViewModel {
  final _graphqlService = sl<GraphQLService>();
  final _navService = sl<NavigationService>();
  final _prefsService = sl<SharedPrefsServices>();
  final _favoritesService = sl<FavoritesService>();
  final _alertService = sl<AlertService>();
  final _cartService = sl<CartService>();
  final GenericCubit<ListSearchProducts> _productsCubit =
      GenericCubit<ListSearchProducts>([]);
  final _totalItemsCubit = GenericCubit<int>(0);
  final GenericCubit<bool> _showFAB = GenericCubit<bool>(false);
  final GenericCubit<int> _currentIndex = GenericCubit<int>(1);
  final GenericCubit<bool> _loadingCubit = GenericCubit<bool>(false);
  final GenericCubit<bool> _availableOnlyCubit = GenericCubit<bool>(false);
  final GenericCubit<List<String>> _recentSearchesCubit =
      GenericCubit<List<String>>([]);
  final GenericCubit<bool> _hasQueryCubit = GenericCubit<bool>(false);
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  late final ScrollController _scrollController;

  Timer? _debounce;

  static const int _pageSize = 20;
  static const int _minQueryLength = 2;
  static const int _maxRecentSearches = 10;
  static const double _estimatedRowExtent = 345;
  static const double _fabRevealOffset = 200;

  String _searchTerm = '';
  int _page = 1;
  bool _isFetching = false;
  int? _totalItems;
  int _requestId = 0;

  ListSearchProducts _allProducts = [];

  String _errorMessage = '';

  GenericCubit<FavoritesModel> get _favoritesCubit =>
      _favoritesService.favoritesCubit;

  GenericCubit<CartData> get _cartCubit => _cartService.cartCubit;

  bool get _canFetchMoreItems =>
      _totalItems == null || _allProducts.length < (_totalItems ?? 0);

  bool get _availableOnly => _availableOnlyCubit.state.data;

  void _init() {
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    _setupScrollController();
    _loadRecentSearches();
  }

  void _dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
  }

  void _setupScrollController() {
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final ScrollPosition position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 200 &&
        !_isFetching &&
        _canFetchMoreItems) {
      unawaited(_productsApi(loadMore: true));
    }

    final double offset = _scrollController.offset;
    final bool isFabVisible = _showFAB.state.data;

    _currentIndex.onUpdateData((offset / _estimatedRowExtent).round() + 1);

    if (offset >= _fabRevealOffset && !isFabVisible) {
      _showFAB.onUpdateData(true);
    } else if (offset < _fabRevealOffset && isFabVisible) {
      _showFAB.onUpdateData(false);
    }
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      0,
      duration: AppDurations.entrance,
      curve: Curves.easeInOut,
    );
  }

  void _resetScrollState() {
    _showFAB.onUpdateData(false);
    _currentIndex.onUpdateData(1);
  }

  void _back() {
    _navService.pop();
  }

  void _openImageSearch() {
    _navService.pushNamed(
      RouteNames.homeComingSoon,
      extra: LocaleKeys.homeSmartSearch.tr(),
    );
  }

  Future<void> _openProductDetails(ProductSearchProductModel product) async {
    if (product.sku.isEmpty) return;

    await _rememberSearch(_searchTerm);

    _navService.pushNamed(
      RouteNames.productDetails,
      extra: ProductDetailsArgs(
        sku: product.sku,
        title: product.name,
        imagePath: product.imageUrl,
      ),
    );
  }

  Future<void> _toggleFavorite(ProductSearchProductModel product) async {
    await _favoritesService.toggleFavorite(
      FavoriteProductModel(
        id: product.sku,
        title: product.name,
        imagePath: product.imageUrl,
        price: product.finalPrice.toStringAsFixed(2),
        oldPrice: product.hasDiscount
            ? product.regularPrice.toStringAsFixed(2)
            : '',
        category: '',
        description: '',
      ),
    );
  }

  Future<void> _addToCart({
    required String sku,
    required int quantity,
  }) async {
    if (sku.trim().isEmpty) return;

    if (await _cartService.addProduct(sku: sku, quantity: quantity)) {
      _alertService.showSuccess(LocaleKeys.cartAddedSuccess.tr());

      return;
    }

    final String message = _cartService.data.errorMessage;

    _alertService.showError(
      message.trim().isEmpty ? LocaleKeys.somethingWentWrong.tr() : message,
    );
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();

    final String query = value.trim();

    if (query.length < _minQueryLength) {

      _requestId++;

      _searchTerm = '';
      _errorMessage = '';
      _allProducts = [];
      _page = 1;
      _totalItems = null;

      _totalItemsCubit.onUpdateData(0);
      _hasQueryCubit.onUpdateData(false);

      return;
    }

    _debounce = Timer(
      AppDurations.searchDebounce,
      () => _productsSearch(query),
    );
  }

  Future<void> _onQuerySubmitted(String value) async {
    _debounce?.cancel();

    final String query = value.trim();

    if (query.length < _minQueryLength) return;

    _productsSearch(query);

    await _rememberSearch(query);
  }

  void _onClearQuery() {
    _searchController.clear();
    _onQueryChanged('');
    _searchFocusNode.requestFocus();
  }

  void _toggleAvailableOnly() {
    _availableOnlyCubit.onUpdateData(!_availableOnly);

    if (_searchTerm.length < _minQueryLength) return;

    _productsSearch(_searchTerm);
  }

  void _onRecentSearchTap(String query) {
    _debounce?.cancel();

    _searchController.text = query;
    _searchController.selection = TextSelection.collapsed(offset: query.length);

    _searchFocusNode.unfocus();

    _productsSearch(query);
  }

  void _productsSearch(String query) {
    _searchTerm = query.trim();

    _requestId++;
    _page = 1;
    _totalItems = null;

    _hasQueryCubit.onUpdateData(_searchTerm.length >= _minQueryLength);

    _resetScrollState();

    _loadingCubit.onUpdateData(true);

    unawaited(_productsApi());
  }

  Future<void> _refresh() async {
    if (_searchTerm.length < _minQueryLength) return;

    _requestId++;
    _page = 1;
    _totalItems = null;

    await _productsApi();
  }

  Future<void> _retry() => _refresh();

  Future<void> _productsApi({bool loadMore = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    final String currentSearch = _searchTerm;
    final int requestId = _requestId;

    try {
      if (LanguageDetector.hasMixedLanguage(currentSearch) && !loadMore) {
        await _searchBothStores(currentSearch, requestId);
      } else {
        await _searchSingleStore(currentSearch, loadMore, requestId);
      }

      if (_isStale(requestId)) return;

      _errorMessage = '';
    } catch (error) {
      if (_isStale(requestId)) return;

      _handleFetchError(error, loadMore: loadMore);
    } finally {
      _isFetching = false;

      if (!_loadingCubit.isClosed) _loadingCubit.onUpdateData(false);
    }
  }

  void _handleFetchError(Object error, {required bool loadMore}) {
    final String message = errorMessageFrom(error);

    if (loadMore || _allProducts.isNotEmpty) {
      _alertService.showError(message);

      _productsCubit.onUpdateData(_allProducts);

      return;
    }

    _errorMessage = message;

    _productsCubit.onUpdateData(const []);
  }

  Future<void> _searchSingleStore(
    String currentSearch,
    bool loadMore,
    int requestId,
  ) async {
    final ProductSearchResponse response = await _fetchPage(
      currentSearch,
      _page,
      storeType: LanguageDetector.storeCodeFor(currentSearch),
    );

    if (_isStale(requestId)) return;

    _totalItems = response.totalCount;
    _totalItemsCubit.onUpdateData(_totalItems ?? 0);

    _allProducts = loadMore
        ? [..._allProducts, ...response.items]
        : response.items;

    _productsCubit.onUpdateData(_allProducts);

    _page++;
  }

  Future<void> _searchBothStores(String currentSearch, int requestId) async {
    Object? firstError;

    Future<ProductSearchResponse?> attempt(String storeType) async {
      try {
        return await _fetchPage(
          currentSearch,
          1,
          storeType: storeType,
          pageSize: _pageSize * 2,
        );
      } catch (error) {
        firstError ??= error;

        return null;
      }
    }

    final List<ProductSearchResponse?> results = await Future.wait([
      attempt(AppStores.arabic),
      attempt(AppStores.defaultView),
    ]);

    if (results.nonNulls.isEmpty) throw firstError!;

    if (_isStale(requestId)) return;

    final ListSearchProducts merged = _mergeAndDeduplicate(
      results[0]?.items ?? const [],
      results[1]?.items ?? const [],
    );

    _allProducts = merged;
    _totalItems = merged.length;

    _totalItemsCubit.onUpdateData(merged.length);
    _productsCubit.onUpdateData(merged);

    _page = 2;
  }

  Future<ProductSearchResponse> _fetchPage(
    String query,
    int page, {
    required String storeType,
    int? pageSize,
  }) async {
    final ProductSearchRequest request = ProductSearchRequest(
      searchText: query,
      pageSize: pageSize ?? _pageSize,
      currentPage: page,
      availableOnly: _availableOnly,
    );

    final Map<String, dynamic> data = await _graphqlService.query(
      GraphQLDocuments.searchProducts,
      variables: request.toVariables(),
      headers: {AppStores.header: storeType},
    );

    return ProductSearchResponse.fromJson(data);
  }

  ListSearchProducts _mergeAndDeduplicate(
    ListSearchProducts arabicItems,
    ListSearchProducts englishItems,
  ) {
    final Map<String, ProductSearchProductModel> unique =
        <String, ProductSearchProductModel>{};

    for (final ProductSearchProductModel product in [
      ...arabicItems,
      ...englishItems,
    ]) {
      if (product.sku.isEmpty) continue;

      unique.putIfAbsent(product.sku, () => product);
    }

    return unique.values.toList();
  }

  bool _isStale(int requestId) {
    return requestId != _requestId || _productsCubit.isClosed;
  }

  void _loadRecentSearches() {
    _recentSearchesCubit.onUpdateData(
      _prefsService.getStringList(PrefKeys.recentSearches),
    );
  }

  Future<void> _rememberSearch(String query) async {
    final String trimmed = query.trim();

    if (trimmed.length < _minQueryLength) return;

    final List<String> updated = [
      trimmed,
      ..._recentSearchesCubit.state.data.where(
        (entry) => entry.toLowerCase() != trimmed.toLowerCase(),
      ),
    ];

    if (updated.length > _maxRecentSearches) {
      updated.removeRange(_maxRecentSearches, updated.length);
    }

    _recentSearchesCubit.onUpdateData(updated);

    await _prefsService.setStringList(PrefKeys.recentSearches, updated);
  }

  Future<void> _removeRecentSearch(String query) async {
    final List<String> updated = _recentSearchesCubit.state.data
        .where((entry) => entry != query)
        .toList();

    _recentSearchesCubit.onUpdateData(updated);

    await _prefsService.setStringList(PrefKeys.recentSearches, updated);
  }
}
