part of '../categories_imports.dart';

class CategoriesViewModel {
  final ApiService apiService;

  CategoriesViewModel(this.apiService);

  final GenericCubit<CategoriesData> categoriesCubit =
  GenericCubit<CategoriesData>(CategoriesData.initial());

  Future<void> loadCategories() async {
    categoriesCubit.onUpdateData(
      categoriesCubit.state.data.copyWith(
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      final response = await apiService.get(endPoint: ApiConstants.categories);

      final category = CategoryModel.fromJson(response.data);

      categoriesCubit.onUpdateData(
        categoriesCubit.state.data.copyWith(
          isLoading: false,
          rootCategory: category,
          selectedParentIndex: 0,
          searchQuery: '',
          clearError: true,
        ),
      );
    } catch (e) {
      categoriesCubit.onUpdateData(
        categoriesCubit.state.data.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
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
