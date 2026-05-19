part of '../home_imports.dart';

class HomeRepository {
  final ApiService _apiService;

  HomeRepository(this._apiService);

  Future<List<HomeCmsResponse>> getHomeData() async {
    final response = await _apiService.get(
      endPoint: ApiConstants.homeCmsPage,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiConstants.token}',
        },
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
    required String sectionKey,
  }) async {
    final response = await _apiService.get(
      endPoint: ApiConstants.products,
      queryParameters: {
        'section': sectionKey,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiConstants.token}',
        },
      ),
    );

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  final apiServices = sl<ApiService>();

  HomeCubit(this._repository) : super(const HomeState());

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
    emit(state.copyWith(
      status: HomeStatus.loading,
      errorMessage: '',
    ));

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
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
