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
      // The badge follows the app-global cart, so it updates from wherever a
      // product was added — not just from the cart tab.
      bottomNavigationBar:
          BlocBuilder<GenericCubit<CartData>, GenericState<CartData>>(
            bloc: sl<CartService>().cartCubit,
            builder: (BuildContext context, GenericState<CartData> state) {
              return HomeBottomNavBar(
                selectedIndex: navigationShell.currentIndex,
                cartCount: state.data.badgeCount,
                onTap: _onTap,
              );
            },
          ),
    );
  }
}
