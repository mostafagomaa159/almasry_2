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
      backgroundColor: AppColors.surfaceScaffold,
      drawer: const AppDrawer(),
      body: navigationShell,
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: navigationShell.currentIndex,
        cartCount: 10,
        onTap: _onTap,
      ),
    );
  }
}
