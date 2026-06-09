part of '../orders_imports.dart';

class OrdersErrorView extends StatelessWidget {
  final String message;

  const OrdersErrorView({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
