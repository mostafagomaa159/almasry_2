part of '../home_imports.dart';

class HomeSuccessContent extends StatelessWidget {
  final HomeViewModel vm;

  const HomeSuccessContent({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final data = vm._data();

    return RefreshIndicator(
      onRefresh: vm._getHomeData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(bottom: 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              10.verticalSpace,

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: const HomeSearchBar(),
              ),

              16.verticalSpace,

              if (data.banners.isNotEmpty) ...[
                HomeBannerSlider(vm: vm),
                18.verticalSpace,
              ],

              const HomeQuickActionsSection(),

              24.verticalSpace,

              HomeSectionsView(vm: vm),
            ],
          ),
        ),
      ),
    );
  }
}
