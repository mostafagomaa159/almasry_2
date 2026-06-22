part of '../categories_imports.dart';

class CategoriesContentView extends StatelessWidget {
  final List<CategoryModel> categories;
  final CategoryModel? selectedParentCategory;
  final List<CategoryModel> filteredChildren;
  final String searchQuery;
  final int selectedParentIndex;
  final TextEditingController searchController;
  final ValueChanged<int> onParentSelected;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const CategoriesContentView({
    super.key,
    required this.categories,
    required this.selectedParentCategory,
    required this.filteredChildren,
    required this.searchQuery,
    required this.selectedParentIndex,
    required this.searchController,
    required this.onParentSelected,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CategoriesSidebar(
          categories: categories,
          selectedIndex: selectedParentIndex,
          onSelect: onParentSelected,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                CategoriesSearchField(
                  controller: searchController,
                  searchQuery: searchQuery,
                  onChanged: onSearchChanged,
                  onClear: onClearSearch,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: CategoriesChildrenSection(
                    parentCategory: selectedParentCategory,
                    childrenCategories: filteredChildren,
                    searchQuery: searchQuery,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
