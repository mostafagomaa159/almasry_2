part of '../orders_imports.dart';

class OrdersLoadingView extends StatelessWidget {
  const OrdersLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
