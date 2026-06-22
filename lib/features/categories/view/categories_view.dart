part of '../categories_imports.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final CategoriesViewModel vm = CategoriesViewModel();

  @override
  void initState() {
    super.initState();
    vm.init();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: BlocBuilder<GenericCubit<List<CategoryModel>>,
          GenericState<List<CategoryModel>>>(
        bloc: vm.categoriesCubit,
        builder: (context, state) {
          if (state is GenericUpdateState<List<CategoryModel>>) {
            if (vm.errorMessage != null && state.data.isEmpty) {
              return CategoriesErrorView(
                message: vm.errorMessage!,
                onRetry: vm.getCategories,
              );
            }

            if (state.data.isEmpty) {
              return const Center(
                child: Text('No categories found'),
              );
            }

            return CategoriesContentView(
              categories: state.data,
              selectedParentCategory: vm.selectedParentCategory,
              filteredChildren: vm.filteredChildren,
              searchQuery: vm.searchQuery,
              selectedParentIndex: vm.selectedParentIndex,
              searchController: vm.searchController,
              onParentSelected: vm.selectParentCategory,
              onSearchChanged: vm.updateSearchQuery,
              onClearSearch: vm.clearSearch,
            );
          } else {
            return const CategoriesLoadingView();
          }
        },
      ),
    );
  }
}
