part of '../categories_imports.dart';

class CategoriesViewModel {
  /// init
  void init() {
    getCategoriesSearch();
  }

  /// services
  final ApiService _apiService = sl<ApiService>();

  /// controllers
  final searchController = TextEditingController();

  /// cubits
  final GenericCubit<List<CategoryModel>> categoriesCubit =
      GenericCubit<List<CategoryModel>>([]);

  /// state values

  int selectedParentIndex = 0;
  String searchQuery = '';
  String? errorMessage;

  /// getters

  List<CategoryModel> get categories => categoriesCubit.state.data;

  CategoryModel? get selectedParentCategory {
    if (categories.isEmpty) return null;
    if (selectedParentIndex < 0 || selectedParentIndex >= categories.length) {
      return categories.first;
    }
    return categories[selectedParentIndex];
  }

  List<CategoryModel> get filteredChildren {
    final List<CategoryModel> children =
        selectedParentCategory?.childrenData ?? <CategoryModel>[];

    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return children;
    }

    return children.where((child) {
      return child.name.toLowerCase().contains(query);
    }).toList();
  }

  /// api

  Future<void> getCategoriesSearch() async {
    if (categoriesCubit.state.data.isEmpty) {
      await getCategories();
    }
  }

  Future<void> getCategories() async {
    errorMessage = null;

    try {
      final response = await _apiService.get(endPoint: ApiConstants.categories);

      final rootCategory = CategoryModel.fromJson(response.data);
      final parentCategories = rootCategory.childrenData;

      selectedParentIndex = 0;
      searchQuery = '';
      searchController.clear();
      errorMessage = null;

      categoriesCubit.onUpdateData(parentCategories);
    } catch (e) {
      errorMessage = _mapErrorToMessage(e);
      categoriesCubit.onUpdateData(<CategoryModel>[]);
    }
  }

  /// actions

  void selectParentCategory(int index) {
    selectedParentIndex = index;
    searchQuery = '';
    searchController.clear();
    categoriesCubit.onUpdateData(List<CategoryModel>.from(categories));
  }

  void updateSearchQuery(String value) {
    searchQuery = value;
    categoriesCubit.onUpdateData(List<CategoryModel>.from(categories));
  }

  void clearSearch() {
    searchQuery = '';
    searchController.clear();
    categoriesCubit.onUpdateData(List<CategoryModel>.from(categories));
  }

  /// helpers

  String _mapErrorToMessage(Object error) {
    return 'Something went wrong';
  }

  void dispose() {
    searchController.dispose();
  }
}
