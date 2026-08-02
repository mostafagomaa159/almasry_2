part of '../orders_imports.dart';

class OrdersBody extends StatelessWidget {
  final OrdersViewModel vm;

  const OrdersBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<List<OrderModel>>,
      GenericState<List<OrderModel>>
    >(
      bloc: vm._ordersCubit,
      builder: (context, state) {
        if (state is GenericUpdateState<List<OrderModel>>) {
          if (state.data.isEmpty) {
            return const OrdersEmptyView();
          }
          return OrdersListView(vm: vm, orders: state.data);
        }
        return const OrdersLoadingView();
      },
    );
  }
}
