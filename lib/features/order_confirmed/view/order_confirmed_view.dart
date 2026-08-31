part of '../order_confirmed_imports.dart';

class OrderConfirmedView extends StatefulWidget {
  final OrderConfirmedArgs args;

  const OrderConfirmedView({super.key, required this.args});

  @override
  State<OrderConfirmedView> createState() => _OrderConfirmedViewState();
}

class _OrderConfirmedViewState extends State<OrderConfirmedView> {
  final OrderConfirmedViewModel vm = OrderConfirmedViewModel();

  @override
  void initState() {
    super.initState();
    vm._init(args: widget.args);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(child: OrderConfirmedBody(vm: vm)),
    );
  }
}
