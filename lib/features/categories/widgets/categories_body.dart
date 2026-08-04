part of '../categories_imports.dart';

class CategoriesBody extends StatelessWidget {
  final CategoriesViewModel vm;

  const CategoriesBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<List<CategoryModel>>,
      GenericState<List<CategoryModel>>
    >(
      bloc: vm._categoriesCubit,
      builder: (context, state) {
        if (state is GenericUpdateState<List<CategoryModel>>) {
          if (state.data.isEmpty) {
            return Center(child: Text(LocaleKeys.categoriesEmpty.tr()));
          }

          return CategoriesContentView(vm: vm);
        } else {
          return const CategoriesLoadingView();
        }
      },
    );
  }
}
