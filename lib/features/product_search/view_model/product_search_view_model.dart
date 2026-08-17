part of '../product_search_imports.dart';

/// Drives the product search screen: debounced search-as-you-type guarded by a
/// request id, a dual-store query for mixed-script terms, scroll paging,
/// recent searches and the scroll-to-top button.
class ProductSearchViewModel {
  final GraphQLService _graphql = sl<GraphQLService>();
  final NavigationService _nav = sl<NavigationService>();
  final SharedPrefsServices _prefs = sl<SharedPrefsServices>();
  final FavoritesService _favorites = sl<FavoritesService>();

  static const int _pageSize = 20;

  static const int _minQueryLength = 2;

  static const int _maxRecentSearches = 10;

  static const double _estimatedRowExtent = 345;

  static const double _fabRevealOffset = 200;

  final GenericCubit<ProductSearchData> _searchCubit =
      GenericCubit<ProductSearchData>(const ProductSearchData());

  final GenericCubit<bool> _showFAB = GenericCubit<bool>(false);
  final GenericCubit<int> _currentIndex = GenericCubit<int>(1);

  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  late final ScrollController _scrollController;

  Timer? _debounce;

  int _requestId = 0;

  ProductSearchData get _data => _searchCubit.state.data;

  GenericCubit<FavoritesModel> get _favoritesCubit => _favorites.favoritesCubit;

  void _init() {
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _scrollController = ScrollController()..addListener(_onScroll);

    _loadRecentSearches();
  }

  void _dispose() {
    _debounce?.cancel();

    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();

    _searchCubit.close();
    _showFAB.close();
    _currentIndex.close();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();

    final String query = value.trim();

    if (query.length < _minQueryLength) {
      _requestId++;

      _searchCubit.onUpdateData(
        _data.copyWith(
          status: ProductSearchStatus.idle,
          query: '',
          products: const [],
          totalCount: 0,
          currentPage: 1,
          isLoadingMore: false,
          clearErrorMessage: true,
        ),
      );

      return;
    }

    _debounce = Timer(AppDurations.searchDebounce, () => _search(query));
  }

  Future<void> _onQuerySubmitted(String value) async {
    _debounce?.cancel();

    final String query = value.trim();

    if (query.length < _minQueryLength) return;

    await _search(query);
    await _rememberSearch(query);
  }

  void _onClearQuery() {
    _searchController.clear();
    _onQueryChanged('');
    _searchFocusNode.requestFocus();
  }

  Future<void> _toggleAvailableOnly() async {
    final bool availableOnly = !_data.availableOnly;

    _searchCubit.onUpdateData(_data.copyWith(availableOnly: availableOnly));

    final String query = _data.query;

    if (query.length < _minQueryLength) return;

    await _search(query);
  }

  void _onRecentSearchTap(String query) {
    _debounce?.cancel();

    _searchController.text = query;
    _searchController.selection = TextSelection.collapsed(offset: query.length);

    _searchFocusNode.unfocus();

    _search(query);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final bool isNearBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;

    if (isNearBottom) _loadMore();

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
    _nav.pop();
  }

  void _openImageSearch() {
    _nav.pushNamed(
      RouteNames.homeComingSoon,
      extra: LocaleKeys.homeSmartSearch.tr(),
    );
  }

  Future<void> _openProductDetails(ProductSearchProductModel product) async {
    if (product.sku.isEmpty) return;

    await _rememberSearch(_data.query);

    _nav.pushNamed(
      RouteNames.productDetails,
      extra: ProductDetailsArgs(
        sku: product.sku,
        title: product.name,
        imagePath: product.imageUrl,
      ),
    );
  }

  Future<void> _toggleFavorite(ProductSearchProductModel product) async {
    await _favorites.toggleFavorite(
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

  Future<void> _refresh() async {
    final String query = _data.query;

    if (query.length < _minQueryLength) return;

    await _search(query);
  }

  Future<void> _retry() => _refresh();

  void _loadRecentSearches() {
    _searchCubit.onUpdateData(
      _data.copyWith(
        recentSearches: _prefs.getStringList(PrefKeys.recentSearches),
      ),
    );
  }

  Future<void> _rememberSearch(String query) async {
    final String trimmed = query.trim();

    if (trimmed.length < _minQueryLength) return;

    final List<String> updated = [
      trimmed,
      ..._data.recentSearches.where(
        (entry) => entry.toLowerCase() != trimmed.toLowerCase(),
      ),
    ];

    if (updated.length > _maxRecentSearches) {
      updated.removeRange(_maxRecentSearches, updated.length);
    }

    _searchCubit.onUpdateData(_data.copyWith(recentSearches: updated));

    await _prefs.setStringList(PrefKeys.recentSearches, updated);
  }

  Future<void> _removeRecentSearch(String query) async {
    final List<String> updated = _data.recentSearches
        .where((entry) => entry != query)
        .toList();

    _searchCubit.onUpdateData(_data.copyWith(recentSearches: updated));

    await _prefs.setStringList(PrefKeys.recentSearches, updated);
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
      availableOnly: _data.availableOnly,
    );

    final Map<String, dynamic> data = await _graphql.query(
      GraphQLDocuments.searchProducts,
      variables: request.toVariables(),

      headers: storeType.isEmpty ? const {} : {'store': storeType},
    );

    return ProductSearchResponse.fromJson(data);
  }

  Future<ProductSearchResponse> _searchBothStores(String query) async {
    Object? firstError;

    Future<ProductSearchResponse?> attempt(String storeType) async {
      try {
        return await _fetchPage(
          query,
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
      attempt('arabic'),
      attempt(''),
    ]);

    if (results.nonNulls.isEmpty) throw firstError!;

    final List<ProductSearchProductModel> merged = _mergeAndDeduplicate(
      results[0]?.items ?? const [],
      results[1]?.items ?? const [],
    );

    return ProductSearchResponse(items: merged, totalCount: merged.length);
  }

  List<ProductSearchProductModel> _mergeAndDeduplicate(
    List<ProductSearchProductModel> arabicItems,
    List<ProductSearchProductModel> englishItems,
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

  Future<void> _search(String query) async {
    final int requestId = ++_requestId;

    _resetScrollState();

    _searchCubit.onUpdateData(
      _data.copyWith(
        status: ProductSearchStatus.loading,
        query: query,
        products: const [],
        totalCount: 0,
        currentPage: 1,
        isLoadingMore: false,
        clearErrorMessage: true,
      ),
    );

    try {
      final ProductSearchResponse response =
          LanguageDetector.hasMixedLanguage(query)
          ? await _searchBothStores(query)
          : await _fetchPage(
              query,
              1,
              storeType: LanguageDetector.storeHeaderFor(query),
            );

      if (_isStale(requestId)) return;

      _searchCubit.onUpdateData(
        _data.copyWith(
          status: ProductSearchStatus.success,
          products: response.items,
          totalCount: response.totalCount,
          currentPage: 1,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      if (_isStale(requestId)) return;

      _searchCubit.onUpdateData(
        _data.copyWith(
          status: ProductSearchStatus.error,
          products: const [],
          errorMessage: errorMessageFrom(error),
        ),
      );
    }
  }

  Future<void> _loadMore() async {
    if (_data.isLoadingMore || !_data.hasMore) return;
    if (_data.status != ProductSearchStatus.success) return;

    final int requestId = ++_requestId;
    final int nextPage = _data.currentPage + 1;
    final String query = _data.query;

    _searchCubit.onUpdateData(_data.copyWith(isLoadingMore: true));

    try {
      final ProductSearchResponse response = await _fetchPage(
        query,
        nextPage,
        storeType: LanguageDetector.storeHeaderFor(query),
      );

      if (_isStale(requestId)) return;

      _searchCubit.onUpdateData(
        _data.copyWith(
          products: [..._data.products, ...response.items],
          totalCount: response.totalCount,
          currentPage: nextPage,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      if (_isStale(requestId)) return;

      _searchCubit.onUpdateData(_data.copyWith(isLoadingMore: false));
    }
  }

  bool _isStale(int requestId) {
    return requestId != _requestId || _searchCubit.isClosed;
  }
}
