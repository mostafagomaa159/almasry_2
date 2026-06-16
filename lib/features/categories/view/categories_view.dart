part of '../categories_imports.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  late final CategoriesViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = sl<CategoriesViewModel>();

    if (viewModel.categoriesCubit.state.data.rootCategory == null) {
      viewModel.loadCategories();
    }
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
                  onSelect: viewModel.selectParentCategory,
                ),
                Expanded(
                  child: CategoriesChildrenSection(
                    parentCategory: data.selectedParentCategory,
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
