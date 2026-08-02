part of '../categories_imports.dart';

class CategoriesSearchField extends StatelessWidget {
  final CategoriesViewModel vm;

  const CategoriesSearchField({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: vm._searchController,
      onChanged: vm._updateSearchQuery,
      decoration: InputDecoration(
        hintText: LocaleKeys.categoriesSearchHint.tr(),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: vm._searchQuery.isNotEmpty
            ? IconButton(
                onPressed: vm._clearSearch,
                icon: const Icon(Icons.close),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
