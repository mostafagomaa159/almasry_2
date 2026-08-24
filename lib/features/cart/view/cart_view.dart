part of '../cart_imports.dart';

/// The cart tab. No `Scaffold` of its own — `LayoutShellView` provides one, so
/// the drawer and the bottom bar stay shared with the other branches.
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
  void dispose() {
    vm._dispose();
    super.dispose();
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
          Expanded(child: CartBody(vm: vm)),
        ],
      ),
    );
  }
}
