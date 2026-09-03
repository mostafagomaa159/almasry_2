part of '../home_imports.dart';

class HomeViewModel {
  final _apiService = sl<ApiService>();
  final _favoritesService = sl<FavoritesService>();
  final _navService = sl<NavigationService>();
  final _pushService = sl<PushNotificationService>();
  final _alertService = sl<AlertService>();
  final _cartService = sl<CartService>();

  final GenericCubit<bool> _loadingCubit = GenericCubit<bool>(false);

  final GenericCubit<_HomeStructure?> _structureCubit =
      GenericCubit<_HomeStructure?>(null);

  final GenericCubit<bool> _productsLoadingCubit = GenericCubit<bool>(false);

  final GenericCubit<int> _bannerIndexCubit = GenericCubit<int>(0);

  final GenericCubit<int> _offerTabCubit = GenericCubit<int>(0);

  late final PageController _bannerController;

  Timer? _bannerTimer;
  int _lastBannersLength = 0;

  String _errorMessage = '';

  List<ProductModel> _bestSellerProducts = const [];
  List<ProductModel> _momBabyProducts = const [];
  List<ProductModel> _homeCareProducts = const [];
  List<ProductModel> _feminineCareProducts = const [];
  List<ProductModel> _menCareProducts = const [];

  _HomeStructure? _structure() => _structureCubit.state.data;

  late final GenericCubit<ListFavorites> _favoritesCubit =
      _favoritesService.favoritesCubit;

  final GenericCubit<Set<String>> _addingSkusCubit = GenericCubit<Set<String>>(
    const <String>{},
  );

  Set<String> _addingSkus() => _addingSkusCubit.state.data;

  HomeViewModel() {
    _bannerController = PageController();
  }

  Future<void> _init() async {
    _pushService.dispatchPendingDeepLink();

    await Future.wait([_favoritesService.loadFavorites(), _getHomeData()]);
  }

  void _dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();

    _loadingCubit.close();
    _structureCubit.close();
    _productsLoadingCubit.close();
    _bannerIndexCubit.close();
    _offerTabCubit.close();
  }

  void _startBannerAutoSlide(int bannersLength) {
    _bannerTimer?.cancel();

    if (bannersLength <= 1) return;

    _bannerTimer = Timer.periodic(AppDurations.bannerInterval, (_) {
      if (!_bannerController.hasClients) return;

      final int currentPage =
          _bannerController.page?.round() ?? _bannerController.initialPage;
      final int nextPage = (currentPage + 1) % bannersLength;

      _bannerController.animateToPage(
        nextPage,
        duration: AppDurations.bannerSlide,
        curve: Curves.easeInOut,
      );
    });
  }

  void _syncBannerTimer(int bannersLength) {
    if (_lastBannersLength == bannersLength) return;

    _lastBannersLength = bannersLength;

    if (bannersLength > 1) {
      _startBannerAutoSlide(bannersLength);
    } else {
      _bannerTimer?.cancel();
    }
  }

  void _changeBannerIndex(int index) {
    _bannerIndexCubit.onUpdateData(index);
  }

  void changeOfferTab(int index) {
    _offerTabCubit.onUpdateData(index);
  }

  void _openProductList(HomeSubCategoryModel item) {
    if (item.id.trim().isEmpty) return;

    _navService.pushNamed(
      RouteNames.productList,
      extra: ProductListArgs(title: item.name, categoryId: item.id),
    );
  }

  void _openProductDetails({
    required String sku,
    required String title,
    required String imagePath,
  }) {
    _navService.pushNamed(
      RouteNames.productDetails,
      extra: ProductDetailsArgs(sku: sku, title: title, imagePath: imagePath),
    );
  }

  Future<void> _toggleFavorite(FavoriteProductModel product) async {
    await _favoritesService.toggleFavorite(product);
  }

  Future<void> _addToCart({required String sku, required int quantity}) async {
    if (sku.trim().isEmpty) return;

    _addingSkusCubit.onUpdateData(<String>{..._addingSkus(), sku});

    final bool added = await _cartService.addToCart(
      sku: sku,
      quantity: quantity,
    );

    _addingSkusCubit.onUpdateData(<String>{..._addingSkus()}..remove(sku));

    if (added) _alertService.showSuccess(LocaleKeys.cartAddedSuccess.tr());
  }

  Future<List<HomeCmsModel>> _fetchHomeData() async {
    final response = await _apiService.get(endPoint: ApiConstants.homeCmsPage);

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map((e) => HomeCmsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> _getSectionProducts({
    required String seeAllQuery,
  }) async {
    final cleanedQuery = seeAllQuery.startsWith('?')
        ? seeAllQuery.substring(1)
        : seeAllQuery;

    final url =
        '${ApiConstants.products}?$cleanedQuery&searchCriteria[pageSize]=20&searchCriteria[currentPage]=1';

    final response = await _apiService.get(endPoint: url);
    final data = response.data;

    if (data is List) {
      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (data is Map<String, dynamic> && data['items'] is List) {
      final List<dynamic> items = data['items'] as List<dynamic>;
      return items
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  Future<List<ProductModel>> _getProductsForBlock(
    HomeMobileBlockModel? block,
  ) async {
    final seeAllQuery = block?.seeAll.trim() ?? '';

    if (seeAllQuery.isEmpty) {
      return [];
    }

    try {
      return await _getSectionProducts(seeAllQuery: seeAllQuery);
    } catch (_) {
      return [];
    }
  }

  Future<void> _getHomeData() async {
    _errorMessage = '';

    _loadingCubit.onUpdateData(true);

    try {
      final response = await _fetchHomeData();
      final _HomeStructure structure = _mapHomeStructure(response);

      _bestSellerProducts = const [];
      _momBabyProducts = const [];
      _homeCareProducts = const [];
      _feminineCareProducts = const [];
      _menCareProducts = const [];

      _productsLoadingCubit.onUpdateData(true);
      _loadingCubit.onUpdateData(false);
      _structureCubit.onUpdateData(structure);

      _syncBannerTimer(structure.banners.length);

      await _getSectionProductsFor(structure);
    } catch (e) {
      _errorMessage = e.toString();

      _productsLoadingCubit.onUpdateData(false);
      _loadingCubit.onUpdateData(false);
    }
  }

  Future<void> _getSectionProductsFor(_HomeStructure structure) async {
    final List<List<ProductModel>> sections = await Future.wait([
      _getProductsForBlock(structure.bestSellerBlock),
      _getProductsForBlock(structure.momBabyBlock),
      _getProductsForBlock(structure.homeCareBlock),
      _getProductsForBlock(structure.feminineCareBlock),
      _getProductsForBlock(structure.menCareBlock),
    ]);

    if (_productsLoadingCubit.isClosed) return;

    _bestSellerProducts = sections[0];
    _momBabyProducts = sections[1];
    _homeCareProducts = sections[2];
    _feminineCareProducts = sections[3];
    _menCareProducts = sections[4];

    _productsLoadingCubit.onUpdateData(false);
  }

  _HomeStructure _mapHomeStructure(List<HomeCmsModel> response) {
    List<HomeSliderItemModel> banners = [];
    List<HomeSliderItemModel> secondaryBanners = [];
    List<HomeSubCategoryModel> offers = [];
    List<HomeSubCategoryModel> categories = [];
    List<HomeSubCategoryModel> goals = [];
    List<HomeSubCategoryModel> concerns = [];
    List<HomeBrandModel> brands = [];

    HomeMobileBlockModel? bestSellerBlock;
    HomeMobileBlockModel? momBabyBlock;
    HomeMobileBlockModel? homeCareBlock;
    HomeMobileBlockModel? feminineCareBlock;
    HomeMobileBlockModel? menCareBlock;

    for (final item in response) {
      if (item.slider.isNotEmpty) {
        if (banners.isEmpty) {
          banners = item.slider;
        } else {
          secondaryBanners = item.slider;
        }
      }

      if (item.mobileBlock != null) {
        final mobileBlock = item.mobileBlock!;
        final title = mobileBlock.title.trim().toLowerCase();

        if (title == 'offers') {
          offers = mobileBlock.subCategories;
        } else if (title == 'categories') {
          categories = mobileBlock.subCategories;
        } else if (title == 'bestseller') {
          bestSellerBlock = mobileBlock;
        } else if (title == 'shop by goals') {
          goals = mobileBlock.subCategories;
        } else if (title == 'shop by concerns') {
          concerns = mobileBlock.subCategories;
        } else if (title == 'mom and baby and child care') {
          momBabyBlock = mobileBlock;
        } else if (title == 'home care') {
          homeCareBlock = mobileBlock;
        } else if (title == 'feminine personal care') {
          feminineCareBlock = mobileBlock;
        } else if (title == 'men care') {
          menCareBlock = mobileBlock;
        }
      }

      if (item.brandsData != null) {
        brands = item.brandsData!.brands;
      }
    }

    return _HomeStructure(
      banners: banners,
      secondaryBanners: secondaryBanners,
      offers: offers,
      categories: categories,
      goals: goals,
      concerns: concerns,
      brands: brands,
      bestSellerBlock: bestSellerBlock,
      momBabyBlock: momBabyBlock,
      homeCareBlock: homeCareBlock,
      feminineCareBlock: feminineCareBlock,
      menCareBlock: menCareBlock,
    );
  }
}

class _HomeStructure {
  final List<HomeSliderItemModel> banners;
  final List<HomeSliderItemModel> secondaryBanners;
  final List<HomeSubCategoryModel> offers;
  final List<HomeSubCategoryModel> categories;
  final List<HomeSubCategoryModel> goals;
  final List<HomeSubCategoryModel> concerns;
  final List<HomeBrandModel> brands;
  final HomeMobileBlockModel? bestSellerBlock;
  final HomeMobileBlockModel? momBabyBlock;
  final HomeMobileBlockModel? homeCareBlock;
  final HomeMobileBlockModel? feminineCareBlock;
  final HomeMobileBlockModel? menCareBlock;

  const _HomeStructure({
    required this.banners,
    required this.secondaryBanners,
    required this.offers,
    required this.categories,
    required this.goals,
    required this.concerns,
    required this.brands,
    required this.bestSellerBlock,
    required this.momBabyBlock,
    required this.homeCareBlock,
    required this.feminineCareBlock,
    required this.menCareBlock,
  });
}
