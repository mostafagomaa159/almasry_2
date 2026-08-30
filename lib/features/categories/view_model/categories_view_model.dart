part of '../categories_imports.dart';

class CategoriesViewModel {
  /// Services

  final ApiService _apiService = sl<ApiService>();

  /// Variables

  final TextEditingController _searchController = TextEditingController();

  /// The screen's only cubit. `null` means the categories are still loading;
  /// a list — empty or not — means the request finished.
  final GenericCubit<List<CategoryModel>?> _categoriesCubit =
      GenericCubit<List<CategoryModel>?>(null);

  /// Plain fields, not cubits. Each one is written before the cubit emits, so
  /// the rebuild that emit triggers always reads the matching value.
  String _errorMessage = '';
  int _selectedParentIndex = 0;
  String _searchQuery = '';

  /// Getters

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

  /// Init

  void _init() {
    _getCategories();
  }

  void _dispose() {
    _searchController.dispose();
    _categoriesCubit.close();
  }

  /// Actions

  /// Selection and search are plain fields, so they re-emit the same list to
  /// get a rebuild — `GenericState.changed` makes that work.
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

  /// Api

  Future<void> _getCategories() async {
    _errorMessage = '';
    _selectedParentIndex = 0;
    _searchQuery = '';
    _searchController.clear();

    /// Back to `null` so the spinner replaces whatever was on screen.
    _categoriesCubit.onUpdateData(null);

    try {
      final response = await _apiService.get(endPoint: ApiConstants.categories);

      final CategoryModel rootCategory = CategoryModel.fromJson(response.data);

      _categoriesCubit.onUpdateData(rootCategory.childrenData);
    } catch (error) {
      _errorMessage = errorMessageFrom(error);

      /// Empty list + a message is what the body reads as "error".
      _categoriesCubit.onUpdateData(const []);
    }
  }
}
