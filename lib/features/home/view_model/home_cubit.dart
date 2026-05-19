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

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  final apiServices = sl<ApiService> ();

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

      final List<HomeSliderItemResponse> banners = [];
      final List<HomeSubCategoryResponse> offers = [];
      final List<HomeSubCategoryResponse> goals = [];
      final List<HomeSubCategoryResponse> concerns = [];
      final List<HomeBrandResponse> brands = [];

      for (final item in response) {
        if (item.slider.isNotEmpty) {
          banners.addAll(item.slider);
        }

        if (item.mobileBlock != null) {
          final title = item.mobileBlock!.title.trim().toLowerCase();

          if (title == 'offers') {
            offers.addAll(item.mobileBlock!.subCategories);
          } else if (title == 'shop by goals') {
            goals.addAll(item.mobileBlock!.subCategories);
          } else if (title == 'shop by concerns') {
            concerns.addAll(item.mobileBlock!.subCategories);
          }
        }

        if (item.brandsData != null) {
          brands.addAll(item.brandsData!.brands);
        }
      }

      emit(state.copyWith(
        status: HomeStatus.success,
        banners: banners,
        offers: offers,
        goals: goals,
        concerns: concerns,
        brands: brands,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

}
