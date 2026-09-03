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
    return CartBody(vm: vm);
  }
}
