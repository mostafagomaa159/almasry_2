part of '../my_order_imports.dart';

class OrderDetailsView extends StatefulWidget {
  final OrderDetailsArgs args;

  const OrderDetailsView({super.key, required this.args});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  final OrderDetailsViewModel vm = OrderDetailsViewModel();

  @override
  void initState() {
    super.initState();
    vm._init(orderId: widget.args.orderId.toString());
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${LocaleKeys.orderNumber.tr()}${widget.args.incrementId}'),
      ),
      body: OrderDetailsBody(vm: vm),
    );
  }
}
