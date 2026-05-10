import 'dart:async';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/features/home/data/home_mock_data.dart';
import 'package:almasry_2/features/home/home.dart';
import 'package:almasry_2/features/home/view_model/home_state.dart';
import 'package:almasry_2/features/home/widgets/widgets.dart';
import 'package:almasry_2/features/profile/view_model/profile_args.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  final ProfileArgs? args;

  const HomeScreen({super.key, this.args});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController bannerController;
  Timer? bannerTimer;

  List<String> get banners => HomeMockData.banners;

  @override
  void initState() {
    super.initState();
    bannerController = PageController();
    _startBannerAutoSlide();
  }

  void _startBannerAutoSlide() {
    bannerTimer?.cancel();

    bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !bannerController.hasClients || banners.isEmpty) {
        return;
      }

      final int currentPage =
          bannerController.page?.round() ?? bannerController.initialPage;
      final int nextPage = (currentPage + 1) % banners.length;

      bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    bannerTimer?.cancel();
    bannerController.dispose();
    super.dispose();
  }

  String _buildWelcomeName() {
    final String? firstName = widget.args?.firstName?.trim();
    final String? email = widget.args?.email?.trim();
    final String? phone = widget.args?.phone?.trim();

    if (firstName != null && firstName.isNotEmpty) return firstName;
    if (email != null && email.isNotEmpty) return email;
    if (phone != null && phone.isNotEmpty) return phone;
    if (widget.args?.isGuest == true) return 'Guest';
    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    final String welcomeName = _buildWelcomeName();

    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final HomeCubit homeCubit = context.read<HomeCubit>();

          return Scaffold(
            backgroundColor: const Color(0xFFF8F8F8),
            bottomNavigationBar: HomeBottomNavBar(
              selectedIndex: state.selectedBottomNavIndex,
              onTap: (index) {
                homeCubit.changeBottomNavIndex(index);

                if (index == 0) {
                  context.push(
                    AppRoutes.profile,
                    extra: widget.args,
                  );
                }
              },
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
                              banners: banners,
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
                            HomeProductsSection(
                              isArabic: isArabic,
                            ),
                            SizedBox(height: 22.h),
                            HomeSectionHeader(
                              title: LocaleKeys.homeGoals.tr(),
                            ),
                            SizedBox(height: 12.h),
                            HomeGoalsSection(
                              isArabic: isArabic,
                              items: HomeMockData.goals(),
                            ),
                            SizedBox(height: 18.h),
                            const BrandStrip(),
                            SizedBox(height: 24.h),
                            HomeSectionHeader(
                              title: LocaleKeys.homeBestSelling.tr(),
                            ),
                            SizedBox(height: 16.h),
                            HomeProductsSection(
                              isArabic: isArabic,
                            ),
                            SizedBox(height: 22.h),
                            HomeSectionHeader(
                              title: LocaleKeys.homeConcerns.tr(),
                            ),
                            SizedBox(height: 12.h),
                            HomeConcernsSection(
                              isArabic: isArabic,
                              items: HomeMockData.concerns(),
                            ),
                            SizedBox(height: 22.h),
                            HomeServicesSection(
                              items: HomeMockData.services(),
                            ),
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
