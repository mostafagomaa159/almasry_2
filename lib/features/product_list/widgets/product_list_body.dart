part of '../product_list_imports.dart';
class _ProductListBody extends StatelessWidget {
  final ScrollController scrollController;

  const _ProductListBody({
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      builder: (context, state) {
        if (state.status == ProductListStatus.loading &&
            state.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.status == ProductListStatus.error &&
            state.products.isEmpty) {
          return Center(
            child: Text(state.errorMessage),
          );
        }

        if (state.products.isEmpty) {
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
          itemCount: state.products.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.products.length) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final product = state.products[index];
            final sku = product.sku ?? '';
            final quantity = state.quantities[sku] ?? 1;

            return ProductListItem(
              product: product,
              quantity: state.quantities[sku] ?? 1,
              onIncrement: sku.isEmpty
                  ? () {}
                  : () => context.read<ProductListCubit>().incrementQuantity(sku),
              onDecrement: sku.isEmpty
                  ? () {}
                  : () => context.read<ProductListCubit>().decrementQuantity(sku),
            );


          },
        );
      },
    );
  }
}


