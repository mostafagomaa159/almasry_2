part of '../orders_imports.dart';

class OrdersView extends StatefulWidget {
  final String customerEmail;

  const OrdersView({super.key, required this.customerEmail});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final OrdersViewModel vm = OrdersViewModel();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm._init(email: widget.customerEmail);
    });
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const OrdersAppBar(),
      body: OrdersBody(vm: vm),
    );
  }
}
