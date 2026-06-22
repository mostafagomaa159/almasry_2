part of '../categories_imports.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  late final CategoriesViewModel viewModel;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    viewModel = sl<CategoriesViewModel>();
    searchController = TextEditingController();

    if (viewModel.categoriesCubit.state.data.rootCategory == null) {
      viewModel.loadCategories();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GenericCubit<CategoriesData>>.value(
      value: viewModel.categoriesCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          centerTitle: true,
        ),
        body: BlocBuilder<
            GenericCubit<CategoriesData>,
            GenericState<CategoriesData>>(
          builder: (context, state) {
            final data = state.data;

            if (data.isLoading && data.rootCategory == null) {
              return const CategoriesLoadingView();
            }

            if (data.errorMessage != null && data.rootCategory == null) {
              return CategoriesErrorView(
                message: data.errorMessage!,
                onRetry: viewModel.loadCategories,
              );
            }

            if (data.parentCategories.isEmpty) {
              return const Center(
                child: Text('No categories found'),
              );
            }

            return Row(
              children: [
                CategoriesSidebar(
                  categories: data.parentCategories,
                  selectedIndex: data.selectedParentIndex,
                  onSelect: (index) {
                    searchController.clear();
                    viewModel.selectParentCategory(index);
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        TextField(
                          controller: searchController,
                          onChanged: viewModel.updateSearchQuery,
                          decoration: InputDecoration(
                            hintText: 'Search subcategories...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: data.searchQuery.isNotEmpty
                                ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                viewModel.clearSearch();
                              },
                              icon: const Icon(Icons.close),
                            )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
          },
        ),
      ),
    );
  }
}
