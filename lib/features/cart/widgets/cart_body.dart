part of '../cart_imports.dart';

/// Picks between the skeleton, the error, the empty state and the item list.
///
/// The cubit comes from `CartService`, so it is passed explicitly with `bloc:`
/// rather than resolved from the tree — nothing above this provides it.
class CartBody extends StatelessWidget {
  final CartViewModel vm;

  const CartBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<CartData>, GenericState<CartData>>(
      bloc: vm._cartCubit,
      builder: (BuildContext context, GenericState<CartData> state) {
        final CartData data = state.data;
        final CartModel cart = data.cart;

        // A refresh behind an already-painted list keeps the list, so the
        // skeleton and the error only take over when there is nothing to show.
        if (cart.isEmpty) {
          if (data.status == CartStatus.initial || data.isLoading) {
            return const CartShimmer();
          }

          if (data.status == CartStatus.error) {
            return AppErrorView(message: data.errorMessage, onRetry: vm._retry);
          }

          return const CartEmptyView();
        }

        return Column(
          children: <Widget>[
            Expanded(
              child: AppRefreshIndicator(
                onRefresh: vm._refresh,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: cart.items.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      12.verticalSpace,
                  itemBuilder: (BuildContext context, int index) {
                    final CartItemModel item = cart.items[index];

                    return FadeInUp(
                      duration: const Duration(milliseconds: 250),
                      child: CartItemTile(
                        vm: vm,
                        item: item,
                        isBusy: data.isItemBusy(item.numericId),
                      ),
                    );
                  },
                ),
              ),
            ),

            CartSummary(vm: vm, cart: cart),
          ],
        );
      },
    );
  }
}
