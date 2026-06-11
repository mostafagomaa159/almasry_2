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
    return BlocBuilder<GenericCubit<List<OrderResponse>>,
        GenericState<List<OrderResponse>>>(
      bloc: viewModel.ordersCubit,
      builder: (context, state) {
        if (state is GenericUpdateState<List<OrderResponse>>) {
          if (state.data.isEmpty) {
            return const OrdersEmptyView();
          }

          return OrdersListView(
            orders: state.data,
            onRefresh: onRefresh,
          );
        }

        return const OrdersLoadingView();
      },
    );
  }
}
