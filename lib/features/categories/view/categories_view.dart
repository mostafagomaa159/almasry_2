part of '../categories_imports.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final CategoriesViewModel vm = CategoriesViewModel();
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    vm.getCategoriesIfNeeded();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories'), centerTitle: true),
      body:
          BlocBuilder<GenericCubit<CategoriesData>, GenericState<CategoriesData>>(
            bloc: vm.categoriesCubit,
            builder: (context, state) {
              final data = state.data;
              final categories = data.parentCategories;
              if (data.isLoading && data.rootCategory == null) {
                return const CategoriesLoadingView();
              }
              if (data.errorMessage != null && categories.isEmpty) {
                return CategoriesErrorView(
                  message: data.errorMessage ?? 'Something went wrong',
                  onRetry: vm.getCategories,
                );
              }
              if (categories.isEmpty) {
                return const Center(child: Text('No categories found'));
              }
              return CategoriesContentView(
                data: data,
                searchController: searchController,
                onParentSelected: (index) {
                  searchController.clear();
                  vm.selectParentCategory(index);
                },
                onSearchChanged: vm.updateSearchQuery,
                onClearSearch: () {
                  searchController.clear();
                  vm.clearSearch();
                },
              );
            },
          ),
    );
  }
}
