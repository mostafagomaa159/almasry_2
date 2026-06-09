part of '../orders_imports.dart';

class OrdersView extends StatefulWidget {
  final String customerEmail;

  const OrdersView({super.key, required this.customerEmail});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  late final OrdersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<OrdersViewModel>();
    _loadInitialOrders();
  }

  void _loadInitialOrders() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadInitialOrders(
        email: widget.customerEmail,
        onStateChanged: _refreshView,
      );
    });
  }


  void _refreshView() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onRefresh() {
    return _viewModel.refreshOrders(
      email: widget.customerEmail,
      onStateChanged: _refreshView,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel.ordersCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const OrdersAppBar(),

        body: OrdersBody(viewModel: _viewModel, onRefresh: _onRefresh),
      ),
    );
  }
}
