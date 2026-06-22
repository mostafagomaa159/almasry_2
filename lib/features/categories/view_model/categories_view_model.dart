part of '../categories_imports.dart';

class CategoriesViewModel {
  final ApiService _apiService = sl<ApiService>();

  final GenericCubit<CategoriesData> categoriesCubit =
  GenericCubit<CategoriesData>(CategoriesData.initial());

  void getCategoriesIfNeeded() {
    final data = categoriesCubit.state.data;

    if (data.rootCategory == null && !data.isLoading) {
      getCategories();
    }
  }

  Future<void> getCategories() async {
    final current = categoriesCubit.state.data;

    categoriesCubit.onUpdateData(
      CategoriesData(
        isLoading: true,
        errorMessage: null,
        rootCategory: current.rootCategory,
        selectedParentIndex: current.selectedParentIndex,
        searchQuery: current.searchQuery,
      ),
    );

    try {
      final response = await _apiService.get(endPoint: ApiConstants.categories);

      final category = CategoryModel.fromJson(response.data);

      categoriesCubit.onUpdateData(
        CategoriesData(
          isLoading: false,
          errorMessage: null,
          rootCategory: category,
          selectedParentIndex: 0,
          searchQuery: '',
        ),
      );
    } catch (e) {
      final currentAfterError = categoriesCubit.state.data;

      categoriesCubit.onUpdateData(
        CategoriesData(
          isLoading: false,
          errorMessage: e.toString(),
          rootCategory: currentAfterError.rootCategory,
          selectedParentIndex: currentAfterError.selectedParentIndex,
          searchQuery: currentAfterError.searchQuery,
        ),
      );
    }
  }

  void selectParentCategory(int index) {
    categoriesCubit.onUpdateData(
      categoriesCubit.state.data.copyWith(
        selectedParentIndex: index,
        searchQuery: '',
      ),
    );
  }

  void updateSearchQuery(String value) {
    categoriesCubit.onUpdateData(
      categoriesCubit.state.data.copyWith(searchQuery: value),
    );
  }

  void clearSearch() {
    categoriesCubit.onUpdateData(
      categoriesCubit.state.data.copyWith(searchQuery: ''),
    );
  }
}
