part of '../home_imports.dart';

class HomeScreen extends StatefulWidget {
  final ProfileArgs? args;

  const HomeScreen({super.key, this.args});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController bannerController;
  Timer? bannerTimer;

  @override
  void initState() {
    super.initState();
    bannerController = PageController();
  }

  void _startBannerAutoSlide(int bannersLength) {
    bannerTimer?.cancel();

    if (bannersLength <= 1) return;

    bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !bannerController.hasClients) return;

      final int currentPage =
          bannerController.page?.round() ?? bannerController.initialPage;
      final int nextPage = (currentPage + 1) % bannersLength;

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

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<HomeCubit>()..getHomeData(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.banners.isNotEmpty) {
            _startBannerAutoSlide(state.banners.length);
          } else {
            bannerTimer?.cancel();
          }
        },
        builder: (context, state) {
          final HomeCubit homeCubit = context.read<HomeCubit>();

          return Scaffold(
            backgroundColor: const Color(0xFFF8F8F8),
            bottomNavigationBar: HomeBottomNavBar(
              selectedIndex: state.selectedBottomNavIndex,
              onTap: (index) {
                homeCubit.changeBottomNavIndex(index);

                if (index == 0) {
                  context.push(AppRoutes.profile, extra: widget.args);
                }
              },
            ),
            body: SafeArea(
              top: false,
              child: Column(
                children: [
                  const HomeHeader(),
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (state.status == HomeStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.status == HomeStatus.error) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                state.errorMessage.isEmpty
                                    ? 'Something went wrong'
                                    : state.errorMessage,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: homeCubit.getHomeData,
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

                                  if (state.banners.isNotEmpty) ...[
                                    HomeBannerSlider(
                                      controller: bannerController,
                                      currentIndex: state.currentBannerIndex,
                                      onPageChanged: homeCubit.changeBannerIndex,
                                      banners: state.banners,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],

                                  if (state.offers.isNotEmpty) ...[
                                    HomeSectionHeader(
                                      title: LocaleKeys.homeBestOffers.tr(),
                                    ),
                                    SizedBox(height: 14.h),
                                    HomeOfferTabs(
                                      selectedIndex: state.selectedOfferTabIndex,
                                      onTap: homeCubit.changeOfferTab,
                                    ),
                                    SizedBox(height: 16.h),
                                    HomeOffersSection(
                                      isArabic: isArabic,
                                      items: state.offers,
                                    ),
                                  ],

                                  if (state.goals.isNotEmpty) ...[
                                    SizedBox(height: 22.h),
                                    HomeSectionHeader(
                                      title: LocaleKeys.homeGoals.tr(),
                                    ),
                                    SizedBox(height: 12.h),
                                    HomeGoalsSection(
                                      isArabic: isArabic,
                                      items: state.goals,
                                    ),
                                  ],

                                  if (state.brands.isNotEmpty) ...[
                                    SizedBox(height: 18.h),
                                    BrandStrip(
                                      brands: state.brands,
                                    ),
                                  ],

                                  SizedBox(height: 24.h),
                                  HomeSectionHeader(
                                    title: LocaleKeys.homeBestSelling.tr(),
                                  ),
                                  SizedBox(height: 16.h),
                                  HomeProductsSection(
                                    isArabic: isArabic,
                                    sectionKey: 'best_selling',
                                  ),

                                  if (state.concerns.isNotEmpty) ...[
                                    SizedBox(height: 22.h),
                                    HomeSectionHeader(
                                      title: LocaleKeys.homeConcerns.tr(),
                                    ),
                                    SizedBox(height: 12.h),
                                    HomeConcernsSection(
                                      isArabic: isArabic,
                                      items: state.concerns,
                                    ),
                                  ],

                                  SizedBox(height: 22.h),
                                  HomeServicesSection(
                                    items: const [],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
