part of '../home_imports.dart';

class HomeRepository {
  final ApiService _apiService;

  HomeRepository(this._apiService);

  Future<List<HomeCmsResponse>> getHomeData() async {
    final response = await _apiService.get(
      endPoint: ApiConstants.homeCmsPage,
      options: Options(
        headers: {'Authorization': 'Bearer ${ApiConstants.token}'},
      ),
    );

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map((e) => HomeCmsResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class ProductsRepository {
  final ApiService _apiService;

  ProductsRepository(this._apiService);

  Future<List<ProductResponse>> getSectionProducts({
    required String seeAllQuery,
  }) async {
    final cleanedQuery = seeAllQuery.startsWith('?')
        ? seeAllQuery.substring(1)
        : seeAllQuery;

    final url =
        '${ApiConstants.products}?$cleanedQuery&searchCriteria[pageSize]=20&searchCriteria[currentPage]=1';

    final response = await _apiService.get(
      endPoint: url,
      options: Options(
        headers: {'Authorization': 'Bearer ${ApiConstants.token}'},
      ),
    );

    final data = response.data;



    if (data is List) {
      if (data.isNotEmpty) {

      }

      return data
          .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (data is Map<String, dynamic> && data['items'] is List) {
      final List<dynamic> items = data['items'] as List<dynamic>;

      if (items.isNotEmpty) {
        final first = items.first as Map<String, dynamic>;

      }

      return items
          .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }


  Future<ProductResponse> getProductDetails({
    required String sku,
  }) async {
    final endPoint = '${ApiConstants.products}/$sku';

    try {
      final response = await _apiService.get(
        endPoint: endPoint,
        options: Options(
          headers: {'Authorization': 'Bearer ${ApiConstants.token}'},
        ),
      );

      return ProductResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {

      rethrow;
    }
  }



}


class HomeCubit extends Cubit<HomeState> {

  final HomeRepository _repository;
  final ProductsRepository _productsRepository;

  HomeCubit(this._repository, this._productsRepository)
    : super(const HomeState());

  void changeBannerIndex(int index) {
    emit(state.copyWith(currentBannerIndex: index));
  }

  void changeOfferTab(int index) {
    emit(state.copyWith(selectedOfferTabIndex: index));
  }

  void changeBottomNavIndex(int index) {
    emit(state.copyWith(selectedBottomNavIndex: index));
  }

  Future<void> getHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: ''));

    try {
      final response = await _repository.getHomeData();

      List<HomeSliderItemResponse> banners = [];
      List<HomeSliderItemResponse> secondaryBanners = [];

      List<HomeSubCategoryResponse> offers = [];
      List<HomeSubCategoryResponse> categories = [];
      List<HomeSubCategoryResponse> goals = [];
      List<HomeSubCategoryResponse> concerns = [];
      List<HomeBrandResponse> brands = [];

      HomeMobileBlockResponse? bestSellerBlock;
      HomeMobileBlockResponse? momBabyBlock;
      HomeMobileBlockResponse? homeCareBlock;
      HomeMobileBlockResponse? feminineCareBlock;
      HomeMobileBlockResponse? menCareBlock;

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
      final feminineCareProducts = await _getProductsForBlock(
        feminineCareBlock,
      );
      final menCareProducts = await _getProductsForBlock(menCareBlock);

      emit(
        state.copyWith(
          status: HomeStatus.success,
          errorMessage: '',
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
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<List<ProductResponse>> _getProductsForBlock(
    HomeMobileBlockResponse? block,
  ) async {
    final seeAllQuery = block?.seeAll.trim() ?? '';

    if (seeAllQuery.isEmpty) {
      return [];
    }

    try {
      final products = await _productsRepository.getSectionProducts(
        seeAllQuery: seeAllQuery,
      );

      return products;
    } catch (e) {
      return [];
    }
  }
}
