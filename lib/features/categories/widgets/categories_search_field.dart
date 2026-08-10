part of '../categories_imports.dart';

class CategoriesSearchField extends StatelessWidget {
  final CategoriesViewModel vm;

  const CategoriesSearchField({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppSearchField(
      controller: vm._searchController,
      hintText: LocaleKeys.categoriesSearchHint.tr(),
      onChanged: vm._updateSearchQuery,
      onClear: vm._clearSearch,
      showClear: vm._searchQuery.isNotEmpty,
    );
  }
}
