part of '../orders_imports.dart';

class OrdersBody extends StatelessWidget {
  final OrdersViewModel viewModel;
  final Future<void> Function() onRefresh;

  const OrdersBody({
    super.key,
    required this.viewModel,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const OrdersLoadingView();
    }

    if (viewModel.errorMessage.isNotEmpty) {
      return OrdersErrorView(message: viewModel.errorMessage);
    }

    return BlocBuilder<GenericCubit<List<OrderResponse>>,
        GenericState<List<OrderResponse>>>(
      bloc: viewModel.ordersCubit,
      builder: (context, state) {
        final orders = state.data;

        if (orders.isEmpty) {
          return const OrdersEmptyView();
        }

        return OrdersListView(
          orders: orders,
          onRefresh: onRefresh,
        );
      },
    );
  }
}
