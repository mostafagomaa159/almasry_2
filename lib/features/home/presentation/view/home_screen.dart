import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/features/home/presentation/view_model/home_cubit.dart';
import 'package:almasry_2/features/home/presentation/view_model/home_state.dart';
import 'package:almasry_2/features/home/presentation/widgets/brand_strip.dart';
import 'package:almasry_2/features/home/presentation/widgets/home_banner_slider.dart';
import 'package:almasry_2/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:almasry_2/features/home/presentation/widgets/home_header.dart';
import 'package:almasry_2/features/home/presentation/widgets/home_offer_tabs.dart';
import 'package:almasry_2/features/home/presentation/widgets/home_search_bar.dart';
import 'package:almasry_2/features/home/presentation/widgets/home_section_header.dart';
import 'package:almasry_2/features/home/presentation/widgets/product_card.dart';
import 'package:almasry_2/features/home/presentation/widgets/service_card.dart';
import 'package:almasry_2/features/home/presentation/widgets/wide_info_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController bannerController;

  @override
  void initState() {
    super.initState();
    bannerController = PageController();
  }

  @override
  void dispose() {
    bannerController.dispose();
    super.dispose();
  }

  Widget _buildProductsList() {
    return SizedBox(
      height: 318.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: 4,
        itemBuilder: (context, index) {
          return const ProductCard();
        },
      ),
    );
  }

  Widget _buildGoalsList() {
    return SizedBox(
      height: 102.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          WideInfoCard(
            title: LocaleKeys.homeGoalFitness.tr(),
            imagePath: 'assets/images/Red_Big_Card.png',
          ),
          WideInfoCard(
            title: LocaleKeys.homeGoalSkinCare.tr(),
            imagePath: 'assets/images/Red_Big_Card.png',
          ),
        ],
      ),
    );
  }

  Widget _buildConcernsList() {
    return SizedBox(
      height: 102.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          WideInfoCard(
            title: LocaleKeys.homeConcernHeadache.tr(),
            imagePath: 'assets/images/Red_Big_Card.png',
          ),
          WideInfoCard(
            title: LocaleKeys.homeConcernTitle.tr(),
            imagePath: 'assets/images/Red_Big_Card.png',
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.88,
        children: [
          ServiceCard(
            iconPath: 'assets/images/Red_Big_Card.png',
            title: LocaleKeys.homeSafeShopping.tr(),
            description: LocaleKeys.homeSafeShoppingDesc.tr(),
          ),
          ServiceCard(
            iconPath: 'assets/images/Red_Big_Card.png',
            title: LocaleKeys.homeFastShipping.tr(),
            description: LocaleKeys.homeFastShippingDesc.tr(),
          ),
          ServiceCard(
            iconPath: 'assets/images/Red_Big_Card.png',
            title: LocaleKeys.homeMoneyBack.tr(),
            description: LocaleKeys.homeMoneyBackDesc.tr(),
          ),
          ServiceCard(
            iconPath: 'assets/images/Red_Big_Card.png',
            title: LocaleKeys.homeCustomerService.tr(),
            description: LocaleKeys.homeCustomerServiceDesc.tr(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final HomeCubit homeCubit = context.read<HomeCubit>();

          return Scaffold(
            backgroundColor: const Color(0xFFF8F8F8),
            bottomNavigationBar: HomeBottomNavBar(
              selectedIndex: state.selectedBottomNavIndex,
              onTap: homeCubit.changeBottomNavIndex,
            ),
            body: SafeArea(
              top: false,
              child: Column(
                children: [
                  const HomeHeader(),
                  Expanded(
                    child: SingleChildScrollView(
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
                            HomeBannerSlider(
                              controller: bannerController,
                              currentIndex: state.currentBannerIndex,
                              onPageChanged: homeCubit.changeBannerIndex,
                            ),
                            SizedBox(height: 24.h),
                            HomeSectionHeader(
                              title: LocaleKeys.homeBestOffers.tr(),
                            ),
                            SizedBox(height: 14.h),
                            HomeOfferTabs(
                              selectedIndex: state.selectedOfferTabIndex,
                              onTap: homeCubit.changeOfferTab,
                            ),
                            SizedBox(height: 16.h),
                            _buildProductsList(),
                            SizedBox(height: 22.h),
                            HomeSectionHeader(
                              title: LocaleKeys.homeGoals.tr(),
                            ),
                            SizedBox(height: 12.h),
                            _buildGoalsList(),
                            SizedBox(height: 18.h),
                            const BrandStrip(),
                            SizedBox(height: 24.h),
                            HomeSectionHeader(
                              title: LocaleKeys.homeBestSelling.tr(),
                            ),
                            SizedBox(height: 16.h),
                            _buildProductsList(),
                            SizedBox(height: 22.h),
                            HomeSectionHeader(
                              title: LocaleKeys.homeConcerns.tr(),
                            ),
                            SizedBox(height: 12.h),
                            _buildConcernsList(),
                            SizedBox(height: 22.h),
                            _buildServicesGrid(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
