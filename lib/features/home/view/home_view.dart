part of '../home_imports.dart';

class HomeView extends StatefulWidget {
  final ProfileArgs? args;

  const HomeView({super.key, this.args});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel vm = HomeViewModel();

  @override
  void initState() {
    super.initState();
    vm._init();
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GenericCubit<FavoritesModel>>.value(
      value: vm._favoritesCubit,
      child: Container(
        color: AppColors.surfaceScaffold,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const HomeHeader(),
              Expanded(child: HomeBodyView(vm: vm)),
            ],
          ),
        ),
      ),
    );
  }
}
