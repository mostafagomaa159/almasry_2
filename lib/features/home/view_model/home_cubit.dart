part of '../home_imports.dart';

class HomeRepository {
  final ApiService _apiService;

  HomeRepository(this._apiService);

  Future<List<HomeCmsResponse>> getHomeData() async {
    print('========== HOME CMS REQUEST START ==========');
    print('ENDPOINT: ${ApiConstants.homeCmsPage}');

    final response = await _apiService.get(
      endPoint: ApiConstants.homeCmsPage,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiConstants.token}',
        },
      ),
    );

    print('HOME CMS RESPONSE STATUS: ${response.statusCode}');
    print('HOME CMS RESPONSE TYPE: ${response.data.runtimeType}');
    print('========== HOME CMS REQUEST END ==========');

    final List<dynamic> data = response.data as List<dynamic>;

    print('HOME CMS ITEMS COUNT: ${data.length}');

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

    print('========== PRODUCTS REQUEST START ==========');
    print('RAW QUERY: $seeAllQuery');
    print('CLEANED QUERY: $cleanedQuery');
    print('FULL ENDPOINT: $url');

    final response = await _apiService.get(
      endPoint: url,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiConstants.token}',
        },
      ),
    );

    print('PRODUCTS RESPONSE STATUS: ${response.statusCode}');
    print('PRODUCTS RESPONSE TYPE: ${response.data.runtimeType}');

    final data = response.data;

    if (data is List) {
      print('PRODUCTS RESPONSE IS LIST');
      print('PRODUCTS COUNT: ${data.length}');
      print('========== PRODUCTS REQUEST END ==========');

      return data
          .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (data is Map<String, dynamic> && data['items'] is List) {
      final List<dynamic> items = data['items'] as List<dynamic>;
      print('PRODUCTS RESPONSE IS MAP WITH ITEMS');
      print('PRODUCTS COUNT: ${items.length}');
      print('========== PRODUCTS REQUEST END ==========');

      return items
          .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    print('PRODUCTS RESPONSE FORMAT NOT MATCHED');
    print('RESPONSE DATA: $data');
    print('========== PRODUCTS REQUEST END ==========');

    return [];
  }

}

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;
  final ProductsRepository _productsRepository;

  HomeCubit(
      this._repository,
      this._productsRepository,
      ) : super(const HomeState());

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
    print('\n\n========== HOME CUBIT getHomeData START ==========');

    emit(state.copyWith(
      status: HomeStatus.loading,
      errorMessage: '',
    ));

    try {
      final response = await _repository.getHomeData();

      print('HOME CMS PARSED SUCCESSFULLY');
      print('TOTAL CMS BLOCKS: ${response.length}');

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
        print('----- CHECKING CMS ITEM -----');

        if (item.slider.isNotEmpty) {
          print('SLIDER FOUND, COUNT: ${item.slider.length}');
          if (banners.isEmpty) {
            banners = item.slider;
            print('MAIN BANNERS ASSIGNED');
          } else {
            secondaryBanners = item.slider;
            print('SECONDARY BANNERS ASSIGNED');
          }
        }

        if (item.mobileBlock != null) {
          final mobileBlock = item.mobileBlock!;
          final title = mobileBlock.title.trim().toLowerCase();

          print('MOBILE BLOCK TITLE: ${mobileBlock.title}');
          print('MOBILE BLOCK SEE ALL: ${mobileBlock.seeAll}');

          if (title == 'offers') {
            offers = mobileBlock.subCategories;
            print('OFFERS BLOCK ASSIGNED');
          } else if (title == 'categories') {
            categories = mobileBlock.subCategories;
            print('CATEGORIES BLOCK ASSIGNED');
          } else if (title == 'bestseller') {
            bestSellerBlock = mobileBlock;
            print('BESTSELLER BLOCK ASSIGNED');
          } else if (title == 'shop by goals') {
            goals = mobileBlock.subCategories;
            print('GOALS BLOCK ASSIGNED');
          } else if (title == 'shop by concerns') {
            concerns = mobileBlock.subCategories;
            print('CONCERNS BLOCK ASSIGNED');
          } else if (title == 'mom and baby and child care') {
            momBabyBlock = mobileBlock;
            print('MOM BABY BLOCK ASSIGNED');
          } else if (title == 'home care') {
            homeCareBlock = mobileBlock;
            print('HOME CARE BLOCK ASSIGNED');
          } else if (title == 'feminine personal care') {
            feminineCareBlock = mobileBlock;
            print('FEMININE CARE BLOCK ASSIGNED');
          } else if (title == 'men care') {
            menCareBlock = mobileBlock;
            print('MEN CARE BLOCK ASSIGNED');
          }
        }

        if (item.brandsData != null) {
          brands = item.brandsData!.brands;
          print('BRANDS FOUND, COUNT: ${brands.length}');
        }
      }

      print('\n========== START LOADING PRODUCTS ==========');

      final bestSellerProducts = await _getProductsForBlock(bestSellerBlock);
      final momBabyProducts = await _getProductsForBlock(momBabyBlock);
      final homeCareProducts = await _getProductsForBlock(homeCareBlock);
      final feminineCareProducts = await _getProductsForBlock(feminineCareBlock);
      final menCareProducts = await _getProductsForBlock(menCareBlock);

      print('\n========== PRODUCTS LOADING FINISHED ==========');
      print('BESTSELLER PRODUCTS: ${bestSellerProducts.length}');
      print('MOM BABY PRODUCTS: ${momBabyProducts.length}');
      print('HOME CARE PRODUCTS: ${homeCareProducts.length}');
      print('FEMININE CARE PRODUCTS: ${feminineCareProducts.length}');
      print('MEN CARE PRODUCTS: ${menCareProducts.length}');

      emit(state.copyWith(
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
      ));

      print('========== HOME CUBIT getHomeData SUCCESS ==========\n\n');
    } catch (e) {
      print('========== HOME CUBIT getHomeData ERROR ==========');
      print('ERROR: $e');
      print('========== HOME CUBIT getHomeData END WITH ERROR ==========\n\n');

      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<List<ProductResponse>> _getProductsForBlock(
      HomeMobileBlockResponse? block,
      ) async {
    print('\n----- _getProductsForBlock START -----');
    print('BLOCK TITLE: ${block?.title}');
    print('BLOCK SEE ALL: ${block?.seeAll}');

    final seeAllQuery = block?.seeAll.trim() ?? '';

    if (seeAllQuery.isEmpty) {
      print('SEE ALL QUERY IS EMPTY -> RETURN []');
      print('----- _getProductsForBlock END -----\n');
      return [];
    }

    try {
      final products = await _productsRepository.getSectionProducts(
        seeAllQuery: seeAllQuery,
      );

      print('BLOCK PRODUCTS COUNT: ${products.length}');
      print('----- _getProductsForBlock SUCCESS END -----\n');
      return products;
    } catch (e) {
      print('BLOCK REQUEST ERROR FOR: ${block?.title}');
      print('ERROR: $e');
      print('----- _getProductsForBlock ERROR END -----\n');
      return [];
    }
  }
}
