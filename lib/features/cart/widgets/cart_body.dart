part of '../cart_imports.dart';

class CartBody extends StatelessWidget {
  final CartViewModel vm;

  const CartBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<CartModel>, GenericState<CartModel>>(
      bloc: vm._cartCubit,
      builder: (BuildContext context, GenericState<CartModel> state) {
        final CartModel cart = state.data;

        if (cart.isEmpty) {
          return _CartPlaceholder(
            vm: vm,
            hasLoaded: state is GenericUpdateState,
          );
        }

        return Column(
          children: <Widget>[
            Expanded(
              child: CustomAppRefreshIndicator(
                onRefresh: vm._refresh,
                child: _CartItemList(vm: vm, cart: cart),
              ),
            ),

            CartSummary(vm: vm, cart: cart),
          ],
        );
      },
    );
  }
}

class _CartPlaceholder extends StatelessWidget {
  const _CartPlaceholder({required this.vm, required this.hasLoaded});

  final CartViewModel vm;
  final bool hasLoaded;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._loadingCubit,
      builder: (BuildContext context, GenericState<bool> state) {
        if (!hasLoaded || state.data) return const CartShimmer();

        if (vm._cartService.errorMessage.isNotEmpty) {
          return CustomAppErrorView(
            message: vm._cartService.errorMessage,
            onRetry: vm._retry,
          );
        }

        return const CartEmptyView();
      },
    );
  }
}

class _CartItemList extends StatelessWidget {
  const _CartItemList({required this.vm, required this.cart});

  final CartViewModel vm;
  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<Set<int>>, GenericState<Set<int>>>(
      bloc: vm._busyItemsCubit,
      builder: (BuildContext context, GenericState<Set<int>> state) {
        final Set<int> busyItemIds = state.data;

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                isBusy: busyItemIds.contains(item.numericId),
              ),
            );
          },
        );
      },
    );
  }
}
