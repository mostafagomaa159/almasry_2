part of '../home_imports.dart';

class HomeSuccessContent extends StatelessWidget {
  final HomeModel data;
  final PageController bannerController;
  final Future<void> Function() onRefresh;
  final ValueChanged<int> onBannerPageChanged;

  const HomeSuccessContent({
    super.key,
    required this.data,
    required this.bannerController,
    required this.onRefresh,
    required this.onBannerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(bottom: 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: const HomeSearchBar(),
              ),

              SizedBox(height: 16.h),

              if (data.banners.isNotEmpty) ...[
                HomeBannerSlider(
                  controller: bannerController,
                  currentIndex: data.currentBannerIndex,
                  onPageChanged: onBannerPageChanged,
                  banners: data.banners,
                ),
                SizedBox(height: 18.h),
              ],

              const HomeQuickActionsSection(),

              SizedBox(height: 24.h),

              HomeSectionsView(
                data: data,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
