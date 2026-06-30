part of '../home_imports.dart';

class HomeBodyView extends StatelessWidget {
  final HomeModel data;
  final PageController bannerController;
  final Future<void> Function() onRefresh;
  final ValueChanged<int> onBannerPageChanged;

  const HomeBodyView({
    super.key,
    required this.data,
    required this.bannerController,
    required this.onRefresh,
    required this.onBannerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isLoading) {
      return const HomeLoadingView();
    }

    if (data.errorMessage != null && data.errorMessage!.isNotEmpty) {
      return HomeErrorView(message: data.errorMessage!);
    }

    return HomeSuccessContent(
      data: data,
      bannerController: bannerController,
      onRefresh: onRefresh,
      onBannerPageChanged: onBannerPageChanged,
    );
  }
}
