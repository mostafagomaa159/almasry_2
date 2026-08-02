part of '../product_list_imports.dart';

class _ProductListBody extends StatelessWidget {
  final ProductListViewModel vm;

  const _ProductListBody({required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<ProductListData>,
      GenericState<ProductListData>
    >(
      bloc: vm._productListCubit,
      builder: (context, state) {
        final data = vm._data;

        if (data.status == ProductListStatus.loading && data.products.isEmpty) {
          return const _ProductListLoading();
        }

        if (data.status == ProductListStatus.error && data.products.isEmpty) {
          return Center(child: Text(data.errorMessage));
        }

        if (data.products.isEmpty) {
          return Center(child: Text(LocaleKeys.noProductsFound.tr()));
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
          itemCount: data.products.length + (data.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= data.products.length) {
              return const Center(child: CircularProgressIndicator());
            }

            return ProductListItem(vm: vm, product: data.products[index]);
          },
        );
      },
    );
  }
}
