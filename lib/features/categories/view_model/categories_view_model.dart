part of '../categories_imports.dart';

class CategoriesViewModel {
  final _apiService = sl<ApiService>();

  final TextEditingController _searchController = TextEditingController();

  final GenericCubit<List<CategoryModel>?> _categoriesCubit =
      GenericCubit<List<CategoryModel>?>(null);

  String _errorMessage = '';
  int _selectedParentIndex = 0;
  String _searchQuery = '';

  List<CategoryModel> _categories() => _categoriesCubit.state.data ?? const [];

  CategoryModel? _selectedParentCategory() {
    if (_categories().isEmpty) return null;

    if (_selectedParentIndex < 0 ||
        _selectedParentIndex >= _categories().length) {
      return _categories().first;
    }

    return _categories()[_selectedParentIndex];
  }

  List<CategoryModel> _filteredChildren() {
    final List<CategoryModel> children =
        _selectedParentCategory()?.childrenData ?? <CategoryModel>[];

    final String query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) return children;

    return children.where((child) {
      return child.name.toLowerCase().contains(query);
    }).toList();
  }

  void _init() {
    _getCategories();
  }

  void _dispose() {
    _searchController.dispose();
    _categoriesCubit.close();
  }

  void _selectParentCategory(int index) {
    _selectedParentIndex = index;
    _searchQuery = '';
    _searchController.clear();

    _categoriesCubit.onUpdateData(_categories());
  }

  void _updateSearchQuery(String value) {
    _searchQuery = value;

    _categoriesCubit.onUpdateData(_categories());
  }

  void _clearSearch() {
    _searchQuery = '';
    _searchController.clear();

    _categoriesCubit.onUpdateData(_categories());
  }

  Future<void> _retry() async {
    await _getCategories();
  }

  Future<void> _getCategories() async {
    _errorMessage = '';
    _selectedParentIndex = 0;
    _searchQuery = '';
    _searchController.clear();

    _categoriesCubit.onUpdateData(null);

    try {
      final response = await _apiService.get(endPoint: ApiConstants.categories);

      final CategoryModel rootCategory = CategoryModel.fromJson(response.data);

      _categoriesCubit.onUpdateData(rootCategory.childrenData);
    } catch (error) {
      _errorMessage = errorMessageFrom(error);

      _categoriesCubit.onUpdateData(const []);
    }
  }
}
