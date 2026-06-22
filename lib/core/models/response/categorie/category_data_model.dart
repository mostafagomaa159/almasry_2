import 'package:almasry_2/core/models/response/categorie/category_model.dart';

class CategoriesData {
  final bool isLoading;
  final String? errorMessage;
  final CategoryModel? rootCategory;
  final int selectedParentIndex;
  final String searchQuery;

  const CategoriesData({
    required this.isLoading,
    required this.errorMessage,
    required this.rootCategory,
    required this.selectedParentIndex,
    required this.searchQuery,
  });

  factory CategoriesData.initial() {
    return const CategoriesData(
      isLoading: false,
      errorMessage: null,
      rootCategory: null,
      selectedParentIndex: 0,
      searchQuery: '',
    );
  }

  CategoriesData copyWith({
    bool? isLoading,
    String? errorMessage,
    CategoryModel? rootCategory,
    int? selectedParentIndex,
    String? searchQuery,
    bool clearError = false,
  }) {
    return CategoriesData(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      rootCategory: rootCategory ?? this.rootCategory,
      selectedParentIndex: selectedParentIndex ?? this.selectedParentIndex,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<CategoryModel> get parentCategories {
    return rootCategory?.childrenData ?? [];
  }

  CategoryModel? get selectedParentCategory {
    final list = parentCategories;
    if (list.isEmpty) return null;
    if (selectedParentIndex < 0 || selectedParentIndex >= list.length) {
      return list.first;
    }
    return list[selectedParentIndex];
  }

  List<CategoryModel> get selectedChildren {
    return selectedParentCategory?.childrenData ?? [];
  }

  List<CategoryModel> get filteredChildren {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return selectedChildren;
    }

    return selectedChildren.where((category) {
      final name = (category.name ?? '').toLowerCase();
      return name.contains(query);
    }).toList();
  }
}
