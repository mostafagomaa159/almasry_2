part of '../cart_imports.dart';

class CartBody extends StatelessWidget {
  final CartViewModel vm;

  const CartBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<CartModel>, GenericState<CartModel>>(
      bloc: vm._cartCubit,
      builder: (context, state) {
        if (state is GenericUpdateState) {
          final cart = state.data;

          if (cart.isEmpty) return const CartEmptyView();

          return _CartContent(vm: vm, cart: cart);
        }
        return const CartShimmer();
      },
    );
  }
}
