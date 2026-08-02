part of '../home_imports.dart';

class HomeSuccessContent extends StatelessWidget {
  final HomeViewModel vm;

  const HomeSuccessContent({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final data = vm._data;

    return RefreshIndicator(
      onRefresh: vm._getHomeData,
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
                HomeBannerSlider(vm: vm),
                SizedBox(height: 18.h),
              ],

              const HomeQuickActionsSection(),

              SizedBox(height: 24.h),

              HomeSectionsView(vm: vm),
            ],
          ),
        ),
      ),
    );
  }
}
