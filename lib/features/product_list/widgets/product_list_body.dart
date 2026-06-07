part of '../product_list_imports.dart';

class _ProductListBody extends StatelessWidget {
  const _ProductListBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      builder: (context, state) {
        if (state.status == ProductListStatus.loading) {
          return const _ProductListLoading();
        }

        if (state.status == ProductListStatus.error) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                state.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        if (state.products.isEmpty) {
          return Center(
            child: Text(
              'No products found',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: state.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.58,
          ),
          itemBuilder: (context, index) {
            final product = state.products[index];
            return ProductListItem(product: product);
          },
        );
      },
    );
  }
}
