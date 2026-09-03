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
      bottomNavigationBar: BlocBuilder<GenericCubit<int>, GenericState<int>>(
        bloc: sl<CheckoutFlowService>().stepCubit,
        builder: (BuildContext context, GenericState<int> stepState) {
          if (stepState.data > CheckoutFlowService.cartStep) {
            return const SizedBox.shrink();
          }

          return BlocBuilder<GenericCubit<CartModel>, GenericState<CartModel>>(
            bloc: sl<CartService>().cartCubit,
            builder: (BuildContext context, GenericState<CartModel> state) {
              return HomeBottomNavBar(
                selectedIndex: navigationShell.currentIndex,
                cartCount: state.data.productCount,
                onTap: _onTap,
              );
            },
          );
        },
      ),
    );
  }
}
