part of '../categories_imports.dart';

class CategoriesViewModel {
  /// Services

  final ApiService _apiService = sl<ApiService>();

  /// Variables

  final TextEditingController _searchController = TextEditingController();

  final GenericCubit<List<CategoryModel>> _categoriesCubit =
      GenericCubit<List<CategoryModel>>([]);

  int _selectedParentIndex = 0;
  String _searchQuery = '';

  String? errorMessage;

  /// Getters

  List<CategoryModel> get _categories => _categoriesCubit.state.data;

  CategoryModel? get _selectedParentCategory {
    if (_categories.isEmpty) return null;
    if (_selectedParentIndex < 0 ||
        _selectedParentIndex >= _categories.length) {
      return _categories.first;
    }
    return _categories[_selectedParentIndex];
  }

  List<CategoryModel> get _filteredChildren {
    final List<CategoryModel> children =
        _selectedParentCategory?.childrenData ?? <CategoryModel>[];

    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return children;
    }

    return children.where((child) {
      return child.name.toLowerCase().contains(query);
    }).toList();
  }

  /// Init

  void _init() {
    _getCategoriesSearch();
  }

  void _dispose() {
    _searchController.dispose();
    _categoriesCubit.close();
  }

  /// Actions

  void _selectParentCategory(int index) {
    _selectedParentIndex = index;
    _searchQuery = '';
    _searchController.clear();
    _categoriesCubit.onUpdateData(List<CategoryModel>.from(_categories));
  }

  void _updateSearchQuery(String value) {
    _searchQuery = value;
    _categoriesCubit.onUpdateData(List<CategoryModel>.from(_categories));
  }

  void _clearSearch() {
    _searchQuery = '';
    _searchController.clear();
    _categoriesCubit.onUpdateData(List<CategoryModel>.from(_categories));
  }

  /// Helpers

  String _mapErrorToMessage(Object error) {
    return 'Something went wrong';
  }

  /// Api

  Future<void> _getCategoriesSearch() async {
    if (_categoriesCubit.state.data.isEmpty) {
      await _getCategories();
    }
  }

  Future<void> _getCategories() async {
    errorMessage = null;

    try {
      final response = await _apiService.get(endPoint: ApiConstants.categories);

      final rootCategory = CategoryModel.fromJson(response.data);
      final parentCategories = rootCategory.childrenData;

      _selectedParentIndex = 0;
      _searchQuery = '';
      _searchController.clear();
      errorMessage = null;

      _categoriesCubit.onUpdateData(parentCategories);
    } catch (e) {
      errorMessage = _mapErrorToMessage(e);
      _categoriesCubit.onUpdateData(<CategoryModel>[]);
    }
  }
}
