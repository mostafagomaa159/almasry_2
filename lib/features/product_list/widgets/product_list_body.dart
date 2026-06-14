part of '../product_list_imports.dart';

class _ProductListBody extends StatelessWidget {
  final ScrollController scrollController;
  final ProductListViewModel viewModel;

  const _ProductListBody({
    required this.scrollController,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        GenericCubit<ProductListData>,
        GenericState<ProductListData>>(
      bloc: viewModel.productListCubit,
      builder: (context, state) {
        final data = state.data;

        if (data.status == ProductListStatus.loading &&
            data.products.isEmpty) {
          return const _ProductListLoading();
        }

        if (data.status == ProductListStatus.error &&
            data.products.isEmpty) {
          return Center(
            child: Text(data.errorMessage),
          );
        }

        if (data.products.isEmpty) {
          return const Center(
            child: Text('No products found'),
          );
        }

        return GridView.builder(
          controller: scrollController,
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final product = data.products[index];
            final sku = product.sku ?? '';
            final quantity = data.quantities[sku] ?? 1;

            return ProductListItem(
              product: product,
              quantity: quantity,
              onIncrement: sku.isEmpty
                  ? () {}
                  : () => viewModel.incrementQuantity(sku),
              onDecrement: sku.isEmpty
                  ? () {}
                  : () => viewModel.decrementQuantity(sku),
              onTap: () => viewModel.navToProductDetails(context, product),
            );
          },
        );
      },
    );
  }
}
