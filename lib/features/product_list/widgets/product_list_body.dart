part of '../product_list_imports.dart';

class _ProductListBody extends StatelessWidget {
  final ProductListViewModel vm;

  const _ProductListBody({required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<List<ProductModel>?>,
      GenericState<List<ProductModel>?>
    >(
      bloc: vm._productsCubit,
      builder: (context, state) {
        final List<ProductModel>? products = state.data;

        if (products == null) return const AppLoadingView();

        if (products.isEmpty) {
          if (vm._errorMessage.isNotEmpty) {
            return AppErrorView(
              message: vm._errorMessage,
              onRetry: vm._loadInitialProducts,
            );
          }

          return AppEmptyView(message: LocaleKeys.noProductsFound.tr());
        }

        return GridView.builder(
          controller: vm._scrollController,
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.58,
          ),
          itemCount: products.length + (vm._isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= products.length) {
              return const Center(child: CircularProgressIndicator());
            }

            return ProductListItem(vm: vm, product: products[index]);
          },
        );
      },
    );
  }
}
