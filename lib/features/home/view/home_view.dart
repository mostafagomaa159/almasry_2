part of '../home_imports.dart';

class HomeView extends StatefulWidget {
  final ProfileArgs? args;

  const HomeView({super.key, this.args});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel()..init();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<HomeModel>, GenericState<HomeModel>>(
      bloc: viewModel.homeCubit,
      builder: (context, state) {
        final data = state.data;

        viewModel.syncBannerTimer(data.banners.length);

        return Container(
          color: const Color(0xFFF8F8F8),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const HomeHeader(),
                Expanded(
                  child: HomeBodyView(
                    data: data,
                    bannerController: viewModel.bannerController,
                    onRefresh: viewModel.getHomeData,
                    onBannerPageChanged: viewModel.changeBannerIndex,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
