part of '../../home/home_imports.dart';

class LayoutShellView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutShellView({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: navigationShell,
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: navigationShell.currentIndex,
        cartCount: 10,
        onTap: _onTap,
      ),
    );
  }
}
