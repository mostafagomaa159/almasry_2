part of '../brands_imports.dart';

class BrandsViewModel {
  /// Services

  final GraphQLService _graphql = sl<GraphQLService>();
  final NavigationService _nav = sl<NavigationService>();

  /// Variables

  static const int _pageSize = 20;

  final GenericCubit<List<BrandModel>?> _brandsCubit =
      GenericCubit<List<BrandModel>?>(null);

  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  Timer? _searchDebounce;

  String _errorMessage = '';
  bool _isLoadingMore = false;

  /// Paging bookkeeping — nothing renders it.
  String _searchQuery = '';
  int _currentPage = 1;
  int _totalPages = 1;

  bool get _hasMore => _currentPage < _totalPages;

  List<BrandModel> get _loadedBrands => _brandsCubit.state.data ?? const [];

  /// Init

  void _init() {
    _searchController = TextEditingController();
    _scrollController = ScrollController()..addListener(_onScroll);

    _getBrands();
  }

  void _dispose() {
    _searchDebounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();

    _brandsCubit.close();
  }

  /// Actions

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (value.trim() == _searchQuery) return;

      _searchQuery = value.trim();

      _getBrands();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final bool isNearBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;

    if (isNearBottom) _loadMore();
  }

  void _back() {
    _nav.pop();
  }

  void _openBrand(BrandModel brand) {
    // TODO: open the brand's product list once the products-by-brand filter
    // is confirmed.
  }

  /// Data

  Future<void> _getBrands() async {
    _currentPage = 1;
    _totalPages = 1;
    _errorMessage = '';
    _isLoadingMore = false;

    /// Back to `null` so the spinner replaces whatever was on screen.
    _brandsCubit.onUpdateData(null);

    await _fetchPage(1);
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    if (_brandsCubit.state.data == null) return;

    _isLoadingMore = true;
    _brandsCubit.onUpdateData(_loadedBrands);

    await _fetchPage(_currentPage + 1);
  }

  Future<void> _retry() async {
    await _getBrands();
  }

  Future<void> _fetchPage(int page) async {
    final bool isFirstPage = page == 1;

    final BrandsRequest request = BrandsRequest(
      page: page,
      pageSize: _pageSize,
      searchQuery: _searchQuery,
    );

    try {
      final Map<String, dynamic> data = await _graphql.query(
        GraphQLDocuments.searchBrands,
        variables: request.toVariables(),
      );

      final GetBrandsResponse response = GetBrandsResponse.fromJson(data);

      _currentPage = page;
      _totalPages = response.pageInfo.totalPages;
      _errorMessage = '';
      _isLoadingMore = false;

      _brandsCubit.onUpdateData(
        isFirstPage ? response.brands : [..._loadedBrands, ...response.brands],
      );
    } catch (error) {
      _isLoadingMore = false;

      /// A failed "load more" keeps the pages already on screen.
      if (!isFirstPage) {
        _brandsCubit.onUpdateData(_loadedBrands);
        return;
      }

      _errorMessage = errorMessageFrom(error);

      /// Empty list + a message is what the body reads as "error".
      _brandsCubit.onUpdateData(const []);
    }
  }
}
