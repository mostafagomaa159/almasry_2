part of '../cart_imports.dart';

class _CartContent extends StatelessWidget {
  final CartViewModel vm;
  final CartModel cart;

  const _CartContent({required this.vm, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: CustomAppRefreshIndicator(
            onRefresh: vm._refreshCart,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: cart.items.length,
              separatorBuilder: (BuildContext context, int index) =>
                  12.verticalSpace,
              itemBuilder: (BuildContext context, int index) {
                final CartItemModel item = cart.items[index];

                return FadeInUp(
                  duration: AppDurations.entrance,
                  child: CartItemTile(vm: vm, item: item),
                );
              },
            ),
          ),
        ),

        CartSummary(vm: vm, cart: cart),
      ],
    );
  }
}
