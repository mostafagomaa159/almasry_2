part of '../home_imports.dart';

class HomeViewModel {
  final ApiService _apiService = sl<ApiService>();
  late final PageController bannerController;
  final GenericCubit<HomeModel> homeCubit =
  GenericCubit<HomeModel>(const HomeModel());

  Future<void> init() async {
    await getHomeData();
  }


  Timer? _bannerTimer;
  int _lastBannersLength = 0;

  HomeViewModel() {
    bannerController = PageController();
  }

  void dispose() {
    _bannerTimer?.cancel();
    bannerController.dispose();
  }

  void startBannerAutoSlide(int bannersLength) {
    _bannerTimer?.cancel();

    if (bannersLength <= 1) return;

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!bannerController.hasClients) return;

      final int currentPage =
          bannerController.page?.round() ?? bannerController.initialPage;
      final int nextPage = (currentPage + 1) % bannersLength;

      bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void syncBannerTimer(int bannersLength) {
    if (_lastBannersLength == bannersLength) return;

    _lastBannersLength = bannersLength;

    if (bannersLength > 1) {
      startBannerAutoSlide(bannersLength);
    } else {
      _bannerTimer?.cancel();
    }
  }


  void changeBannerIndex(int index) {
    homeCubit.onUpdateData(
      homeCubit.state.data.copyWith(currentBannerIndex: index),
    );
  }

  void changeOfferTab(int index) {
    homeCubit.onUpdateData(
      homeCubit.state.data.copyWith(selectedOfferTabIndex: index),
    );
  }

  Future<List<HomeCmsModel>> _fetchHomeData() async {
    final response = await _apiService.get(
      endPoint: ApiConstants.homeCmsPage,
    );

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

  Future<void> getHomeData() async {
    final current = homeCubit.state.data;

    homeCubit.onUpdateData(
      current.copyWith(
        isLoading: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await _fetchHomeData();
      final mapped = await _mapHomeResponse(response);

      homeCubit.onUpdateData(
        homeCubit.state.data.copyWith(
          isLoading: false,
          clearErrorMessage: true,
          banners: mapped.banners,
          secondaryBanners: mapped.secondaryBanners,
          offers: mapped.offers,
          categories: mapped.categories,
          goals: mapped.goals,
          concerns: mapped.concerns,
          brands: mapped.brands,
          bestSellerBlock: mapped.bestSellerBlock,
          momBabyBlock: mapped.momBabyBlock,
          homeCareBlock: mapped.homeCareBlock,
          feminineCareBlock: mapped.feminineCareBlock,
          menCareBlock: mapped.menCareBlock,
          bestSellerProducts: mapped.bestSellerProducts,
          momBabyProducts: mapped.momBabyProducts,
          homeCareProducts: mapped.homeCareProducts,
          feminineCareProducts: mapped.feminineCareProducts,
          menCareProducts: mapped.menCareProducts,
        ),
      );
    } catch (e) {
      homeCubit.onUpdateData(
        homeCubit.state.data.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<_HomeMappedData> _mapHomeResponse(List<HomeCmsModel> response) async {
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

    final bestSellerProducts = await _getProductsForBlock(bestSellerBlock);
    final momBabyProducts = await _getProductsForBlock(momBabyBlock);
    final homeCareProducts = await _getProductsForBlock(homeCareBlock);
    final feminineCareProducts = await _getProductsForBlock(feminineCareBlock);
    final menCareProducts = await _getProductsForBlock(menCareBlock);

    return _HomeMappedData(
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
      bestSellerProducts: bestSellerProducts,
      momBabyProducts: momBabyProducts,
      homeCareProducts: homeCareProducts,
      feminineCareProducts: feminineCareProducts,
      menCareProducts: menCareProducts,
    );
  }
}

class _HomeMappedData {
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
  final List<ProductModel> bestSellerProducts;
  final List<ProductModel> momBabyProducts;
  final List<ProductModel> homeCareProducts;
  final List<ProductModel> feminineCareProducts;
  final List<ProductModel> menCareProducts;

  const _HomeMappedData({
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
    required this.bestSellerProducts,
    required this.momBabyProducts,
    required this.homeCareProducts,
    required this.feminineCareProducts,
    required this.menCareProducts,
  });
}
