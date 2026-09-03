part of '../cart_imports.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartViewModel vm = CartViewModel();

  @override
  void initState() {
    super.initState();
    vm._init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: <Widget>[
          CustomAppBar(
            title: LocaleKeys.cart.tr(),
            onMenu: () => Scaffold.of(context).openDrawer(),
          ),

          Expanded(
            child:
                BlocBuilder<GenericCubit<CartModel>, GenericState<CartModel>>(
                  bloc: vm._cartCubit,
                  builder: (context, state) {
                    if (state is GenericUpdateState) {
                      final cart = state.data;

                      if (cart.isEmpty) return const CartEmptyView();

                      return _CartContent(vm: vm, cart: cart);
                    }
                    return const CartShimmer();
                  },
                ),
          ),
        ],
      ),
    );
  }
}
