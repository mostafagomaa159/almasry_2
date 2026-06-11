part of '../orders_imports.dart';

class OrdersView extends StatefulWidget {
  final String customerEmail;

  const OrdersView({
    super.key,
    required this.customerEmail,
  });

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  late final OrdersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<OrdersViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.init(email: widget.customerEmail);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const OrdersAppBar(),
      body: OrdersBody(
        viewModel: _viewModel,
      ),
    );
  }
}
