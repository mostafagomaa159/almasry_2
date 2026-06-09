part of '../orders_imports.dart';

class OrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OrdersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Orders'),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
