part of '../home_imports.dart';

class MainShellView extends StatelessWidget {
  final Widget child;

  const MainShellView({
    super.key,
    required this.child,
  });

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.categories)) return 1;
    if (location.startsWith(AppRoutes.comingsoonview)) return 2;

    if (location.startsWith(AppRoutes.profile) ||
        location.startsWith(AppRoutes.orders) ||
        location.startsWith(AppRoutes.orderDetails) ||
        location.startsWith(AppRoutes.wishlist) ||
        location.startsWith(AppRoutes.editProfile)) {
      return 3;
    }

    if (location.startsWith(AppRoutes.productList) ||
        location.startsWith(AppRoutes.productDetails)) {
      return 0;
    }

    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.categories);
        break;
      case 2:
        context.go(AppRoutes.comingsoonview);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: child,
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: selectedIndex,
        cartCount: 10,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}