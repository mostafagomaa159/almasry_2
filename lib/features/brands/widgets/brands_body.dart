part of '../brands_imports.dart';

class BrandsBody extends StatelessWidget {
  final BrandsViewModel vm;

  const BrandsBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<List<BrandModel>?>,
      GenericState<List<BrandModel>?>
    >(
      bloc: vm._brandsCubit,
      builder: (context, state) {
        final List<BrandModel>? brands = state.data;

        if (brands == null) return const AppLoadingView();

        if (brands.isEmpty) {
          if (vm._errorMessage.isNotEmpty) {
            return AppErrorView(message: vm._errorMessage, onRetry: vm._retry);
          }

          return AppEmptyView(message: LocaleKeys.brandsEmpty.tr());
        }

        return BrandsGrid(
          vm: vm,
          brands: brands,
          isLoadingMore: vm._isLoadingMore,
        );
      },
    );
  }
}
