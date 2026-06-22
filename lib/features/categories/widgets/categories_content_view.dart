part of '../categories_imports.dart';

class CategoriesContentView extends StatelessWidget {
  final CategoriesData data;
  final TextEditingController searchController;
  final ValueChanged<int> onParentSelected;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const CategoriesContentView({
    super.key,
    required this.data,
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
          categories: data.parentCategories,
          selectedIndex: data.selectedParentIndex,
          onSelect: onParentSelected,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                CategoriesSearchField(
                  controller: searchController,
                  searchQuery: data.searchQuery,
                  onChanged: onSearchChanged,
                  onClear: onClearSearch,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: CategoriesChildrenSection(
                    parentCategory: data.selectedParentCategory,
                    childrenCategories: data.filteredChildren,
                    searchQuery: data.searchQuery,
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
