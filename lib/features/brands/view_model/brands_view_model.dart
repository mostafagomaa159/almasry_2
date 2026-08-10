part of '../brands_imports.dart';

class BrandsViewModel {
  /// Services

  final GraphQLService _graphql = sl<GraphQLService>();
  final NavigationService _nav = sl<NavigationService>();

  /// Variables

  static const int _pageSize = 20;

  final GenericCubit<BrandsData> _brandsCubit = GenericCubit<BrandsData>(
    const BrandsData(),
  );

  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  Timer? _searchDebounce;

  BrandsData get _data => _brandsCubit.state.data;

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
      if (value.trim() == _data.searchQuery) return;

      _brandsCubit.onUpdateData(
        _data.copyWith(searchQuery: value.trim(), currentPage: 1),
      );

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
    _brandsCubit.onUpdateData(
      _data.copyWith(
        status: BrandsStatus.loading,
        clearErrorMessage: true,
        resetBrands: true,
      ),
    );

    await _fetchPage(1);
  }

  Future<void> _loadMore() async {
    if (_data.isLoadingMore || !_data.hasMore) return;
    if (_data.status != BrandsStatus.success) return;

    _brandsCubit.onUpdateData(_data.copyWith(isLoadingMore: true));

    await _fetchPage(_data.currentPage + 1);
  }

  Future<void> _retry() async {
    await _getBrands();
  }

  Future<void> _fetchPage(int page) async {
    final bool isFirstPage = page == 1;

    try {
      final Map<String, dynamic> data = await _graphql.query(
        GraphQLDocuments.searchBrands,
        variables: {
          'page': page,
          'pageSize': _pageSize,
          if (_data.searchQuery.isNotEmpty) 'q': _data.searchQuery,
        },
      );

      final Map<String, dynamic>? getBrands =
          data['getBrands'] as Map<String, dynamic>?;

      final List<BrandModel> brands =
          (getBrands?['brands'] as List<dynamic>? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(BrandModel.fromJson)
              .toList();

      final BrandsPageInfoModel pageInfo =
          getBrands?['page_info'] is Map<String, dynamic>
          ? BrandsPageInfoModel.fromJson(
              getBrands!['page_info'] as Map<String, dynamic>,
            )
          : BrandsPageInfoModel.empty;

      _brandsCubit.onUpdateData(
        _data.copyWith(
          status: BrandsStatus.success,
          brands: isFirstPage ? brands : [..._data.brands, ...brands],
          currentPage: page,
          totalPages: pageInfo.totalPages,
          totalCount: pageInfo.totalCount,
          isLoadingMore: false,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      final String message = _extractGraphQLMessage(error);

      // A failed "load more" keeps the pages already on screen.
      if (!isFirstPage) {
        _brandsCubit.onUpdateData(_data.copyWith(isLoadingMore: false));
        return;
      }

      _brandsCubit.onUpdateData(
        _data.copyWith(
          status: BrandsStatus.error,
          errorMessage: message,
          isLoadingMore: false,
        ),
      );
    }
  }

  String _extractGraphQLMessage(Object error) {
    if (error is GraphQLServiceException && error.message.trim().isNotEmpty) {
      return error.message;
    }

    return LocaleKeys.somethingWentWrong.tr();
  }
}
