part of '../categories_imports.dart';

class CategoriesBody extends StatelessWidget {
  final CategoriesViewModel vm;

  const CategoriesBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<List<CategoryModel>?>,
      GenericState<List<CategoryModel>?>
    >(
      bloc: vm._categoriesCubit,
      builder: (context, state) {
        final List<CategoryModel>? categories = state.data;

        if (categories == null) return const CustomAppLoadingView();

        if (categories.isEmpty) {
          if (vm._errorMessage.isNotEmpty) {
            return CustomAppErrorView(
              message: vm._errorMessage,
              onRetry: vm._retry,
            );
          }

          return CustomAppEmptyView(message: LocaleKeys.categoriesEmpty.tr());
        }

        return CategoriesContentView(vm: vm);
      },
    );
  }
}
