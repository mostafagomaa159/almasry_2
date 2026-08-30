part of '../brands_imports.dart';

typedef ListBrands = List<BrandModel>;

/// Drives the brands screen: a cache-first listing, submit-driven search that
/// queries both store views for mixed-script terms, scroll paging, and the
/// scroll-to-top button.
class BrandsViewModel {
  final NavigationService _navService = sl<NavigationService>();
  final GraphQLService _graphqlService = sl<GraphQLService>();
  final CacheManagerService _cacheService = sl<CacheManagerService>();
  final AlertService _alertService = sl<AlertService>();

  final GenericCubit<ListBrands> _brandsCubit = GenericCubit<ListBrands>([]);
  final GenericCubit<int> _totalItemsCubit = GenericCubit<int>(0);
  final GenericCubit<bool> _showFAB = GenericCubit<bool>(false);
  final GenericCubit<int> _currentIndex = GenericCubit<int>(1);
  final GenericCubit<bool> _clearSearchCubit = GenericCubit<bool>(false);
  final GenericCubit<bool> _loadingCubit = GenericCubit<bool>(false);

  final TextEditingController _searchController = TextEditingController();

  String _searchTerm = '';

  late final ScrollController _scrollController;

  static const int _pageSize = 21;
  static const double _estimatedRowExtent = 175;
  static const double _fabRevealOffset = 200;

  int _page = 1;
  bool _isFetching = false;
  int? _totalItems;

  ListBrands _allBrands = [];
  ListBrands _cachedDefaultBrands = [];
  int? _cachedDefaultTotalItems;

  String _errorMessage = '';

  bool _canFetchMoreItems() =>
      _totalItems == null || _allBrands.length < (_totalItems ?? 0);

  void _init() {
    _setupScrollController();

    unawaited(_cachingApi());
  }

  void _dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
        _canFetchMoreItems()) {
      unawaited(_brandsApi(loadMore: true));
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

  void _back() {
    _navService.pop();
  }

  void _brandClickAction(BrandModel brand) {
    if (brand.id.trim().isEmpty) return;

    _navService.pushNamed(
      RouteNames.productList,
      extra: ProductListArgs(
        title: brand.name,
        categoryId: brand.id,
        isBrand: true,
      ),
    );
  }

  void _onSearchChanged(String value) {
    _clearSearchCubit.onUpdateData(value.trim().isNotEmpty);
  }

  void _clearSearch() {
    _searchController.clear();

    _brandsSearch('');
  }

  void _brandsSearch(String query) {
    _searchTerm = query.trim();
    _clearSearchCubit.onUpdateData(_searchTerm.isNotEmpty);

    _page = 1;
    _totalItems = null;

    if (_searchTerm.isEmpty && _cachedDefaultBrands.isNotEmpty) {
      _allBrands = List<BrandModel>.from(_cachedDefaultBrands);
      _errorMessage = '';

      final int defaultTotal = _cachedDefaultTotalItems ?? _allBrands.length;

      _totalItems = defaultTotal;
      _totalItemsCubit.onUpdateData(defaultTotal);
      _brandsCubit.onUpdateData(_allBrands);

      return;
    }

    _loadingCubit.onUpdateData(true);

    unawaited(_brandsApi());
  }

  Future<void> _cachingApi() async {
    final ListBrands cached = await _cacheService.getCachedData<BrandModel>(
      key: PrefKeys.cachedBrands,
      fromJson: BrandModel.fromJson,
    );

    if (cached.isNotEmpty) {
      _getDataFromCache(cached);

      unawaited(_brandsApi());

      return;
    }

    await _brandsApi();
  }

  void _getDataFromCache(ListBrands cachedData) {
    _searchTerm = '';

    final ListBrands named = _withNames(cachedData);

    _allBrands = named;
    _cachedDefaultBrands = List<BrandModel>.from(named);
    _cachedDefaultTotalItems = named.length;
    _totalItems = named.length;

    _totalItemsCubit.onUpdateData(named.length);
    _brandsCubit.onUpdateData(named);
  }

  Future<void> _refresh() async {
    _page = 1;
    _totalItems = null;

    await _brandsApi();
  }

  Future<void> _retry() => _refresh();

  Future<void> _brandsApi({bool loadMore = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    final String currentSearch = _searchTerm;

    try {
      if (LanguageDetector.hasMixedLanguage(currentSearch) && !loadMore) {
        await _searchBothStores(currentSearch);
      } else {
        await _searchSingleStore(currentSearch, loadMore);
      }

      _errorMessage = '';

      if (currentSearch.isEmpty && !loadMore) {
        _cachedDefaultBrands = List<BrandModel>.from(_allBrands);
        _cachedDefaultTotalItems = _totalItems ?? _allBrands.length;

        await _cacheService.cacheData<BrandModel>(
          data: _allBrands,
          key: PrefKeys.cachedBrands,
          toJson: (BrandModel item) => item.toJson(),
        );
      }
    } catch (error) {
      _handleFetchError(error, loadMore: loadMore);
    } finally {
      _isFetching = false;
      _loadingCubit.onUpdateData(false);
    }
  }

  void _handleFetchError(Object error, {required bool loadMore}) {
    final String message = errorMessageFrom(error);

    if (loadMore || _allBrands.isNotEmpty) {
      _alertService.showError(message);

      _brandsCubit.onUpdateData(_allBrands);

      return;
    }

    _errorMessage = message;

    _brandsCubit.onUpdateData(const []);
  }

  Future<void> _searchSingleStore(String currentSearch, bool loadMore) async {
    final GetBrandsResponse response = await _fetchBrands(
      query: currentSearch,
      page: _page,
      pageSize: _pageSize,
      storeType: LanguageDetector.storeCodeFor(currentSearch),
    );

    _totalItems = response.pageInfo.totalCount;
    _totalItemsCubit.onUpdateData(_totalItems ?? 0);

    final ListBrands newBrands = _withNames(response.brands);

    _allBrands = loadMore ? [..._allBrands, ...newBrands] : newBrands;

    _brandsCubit.onUpdateData(_allBrands);

    _page++;
  }

  Future<void> _searchBothStores(String currentSearch) async {
    final List<ListBrands> results = await Future.wait([
      _fetchBrandsFromStore(currentSearch, storeType: AppStores.arabic),
      _fetchBrandsFromStore(currentSearch, storeType: AppStores.defaultView),
    ]);

    final ListBrands merged = _mergeAndDeduplicateBrands(
      results[0],
      results[1],
    );

    _allBrands = merged;
    _totalItems = merged.length;

    _totalItemsCubit.onUpdateData(merged.length);
    _brandsCubit.onUpdateData(merged);

    _page = 2;
  }

  Future<ListBrands> _fetchBrandsFromStore(
    String query, {
    required String storeType,
  }) async {
    try {
      final GetBrandsResponse response = await _fetchBrands(
        query: query,
        page: 1,
        pageSize: _pageSize * 2,
        storeType: storeType,
      );

      return _withNames(response.brands);
    } catch (_) {
      return const [];
    }
  }

  Future<GetBrandsResponse> _fetchBrands({
    required String query,
    required int page,
    required int pageSize,
    required String storeType,
  }) async {
    final BrandsRequest request = BrandsRequest(
      page: page,
      pageSize: pageSize,
      searchQuery: query,
    );

    final Map<String, dynamic> data = await _graphqlService.query(
      GraphQLDocuments.searchBrands,
      variables: request.toVariables(),
      headers: {AppStores.header: storeType},
    );

    return GetBrandsResponse.fromJson(data);
  }

  ListBrands _mergeAndDeduplicateBrands(
    ListBrands arabicBrands,
    ListBrands englishBrands,
  ) {
    final Map<String, BrandModel> uniqueBrands = <String, BrandModel>{};

    for (final BrandModel brand in [...arabicBrands, ...englishBrands]) {
      if (brand.id.trim().isEmpty) continue;

      uniqueBrands.putIfAbsent(brand.id, () => brand);
    }

    return uniqueBrands.values.toList();
  }

  ListBrands _withNames(ListBrands brands) {
    return brands
        .where((BrandModel brand) => brand.name.trim().isNotEmpty)
        .toList();
  }
}
