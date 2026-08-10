part of '../my_order_imports.dart';

class OrderDetailsBody extends StatelessWidget {
  final OrderDetailsViewModel vm;

  const OrderDetailsBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<OrderDetailsModel>,
      GenericState<OrderDetailsModel>
    >(
      bloc: vm._orderDetailsCubit,
      builder: (context, state) {
        final data = vm._data;

        if (data.isLoading && data.order == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (data.errorMessage != null && data.order == null) {
          return Center(child: Text(data.errorMessage!));
        }

        final order = data.order;

        if (order == null) {
          return Center(child: Text(LocaleKeys.orderDetailsNotFound.tr()));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionCard(
              title: LocaleKeys.orderSummary.tr(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${LocaleKeys.orderStatusLabel.tr()}: ${order.status.name}',
                  ),
                  8.verticalSpace,
                  Text('${LocaleKeys.orderDateLabel.tr()}: ${order.createdAt}'),
                  8.verticalSpace,
                  Text(
                    '${LocaleKeys.orderGrandTotalLabel.tr()}: '
                    '${order.total.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}',
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            _SectionCard(
              title: LocaleKeys.orderItems.tr(),
              child: Column(
                children: [
                  ...order.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == order.items.length - 1 ? 0 : 12,
                      ),
                      child: _OrderItemTile(item: item),
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
