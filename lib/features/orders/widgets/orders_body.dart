part of '../orders_imports.dart';

class OrdersBody extends StatelessWidget {
  final OrdersViewModel viewModel;

  const OrdersBody({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<List<OrderModel>>,
      GenericState<List<OrderModel>>
    >(
      bloc: viewModel.ordersCubit,
      builder: (context, state) {
        if (state is GenericUpdateState<List<OrderModel>>) {
          if (state.data.isEmpty) {
            return const OrdersEmptyView();
          }
          return OrdersListView(orders: state.data);
        }
        return const OrdersLoadingView();
      },
    );
  }
}
