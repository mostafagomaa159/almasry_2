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
                                    SizedBox(height: 18.h),
                                  ],

                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: HomeQuickActionCard(
                                            title: isArabic
                                                ? 'تحليل البشرة'
                                                : 'Skin Analysis',
                                            iconPath: AppImages.redBigCard,
                                            backgroundColor: const Color(0xFFFDEBEC),
                                            onTap: () {},
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: HomeQuickActionCard(
                                            title: isArabic
                                                ? 'الباحث الذكي'
                                                : 'Smart Search',
                                            iconPath: AppImages.redBigCard,
                                            backgroundColor: const Color(0xFFEAF4FF),
                                            onTap: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 24.h),

                                  if (state.offers.isNotEmpty) ...[
                                    HomeSectionHeader(
                                      title: LocaleKeys.homeOffers.tr(),
                                    ),
                                    SizedBox(height: 14.h),
                                    HomeOffersSection(
                                      isArabic: isArabic,
                                      items: state.offers,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],

                                  if (state.categories.isNotEmpty) ...[
                                    HomeSectionHeader(
                                      title: LocaleKeys.homeCategories.tr(),
                                    ),
                                    SizedBox(height: 12.h),
                                    HomeCategoriesSection(
                                      isArabic: isArabic,
                                      items: state.categories,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],

                                  if (state.bestSellerBlock != null) ...[
                                    HomeSectionHeader(
                                      title: LocaleKeys.homeBestSelling.tr(),
                                    ),
                                    SizedBox(height: 16.h),

                                    if (state.bestSellerProducts.isEmpty)
                                      const Center(child: Text('No bestseller products')),

                                    if (state.bestSellerProducts.isNotEmpty)
                                      HomeProductsSection(
                                        isArabic: isArabic,
                                        products: state.bestSellerProducts,
                                      ),

                                    SizedBox(height: 24.h),
                                  ],


                                  if (state.brands.isNotEmpty) ...[
                                    HomeSectionHeader(
                                      title: isArabic ? 'العلامات التجارية' : 'Brands',
                                    ),
                                    SizedBox(height: 12.h),
                                    BrandStrip(
                                      brands: state.brands,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],

                                  if (state.goals.isNotEmpty) ...[
                                    HomeSectionHeader(
                                      title: LocaleKeys.homeGoals.tr(),
                                    ),
                                    SizedBox(height: 12.h),
                                    HomeGoalsSection(
                                      isArabic: isArabic,
                                      items: state.goals,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],

                                  if (state.concerns.isNotEmpty) ...[
                                    HomeSectionHeader(
                                      title: LocaleKeys.homeConcerns.tr(),
                                    ),
                                    SizedBox(height: 12.h),
                                    HomeConcernsSection(
                                      isArabic: isArabic,
                                      items: state.concerns,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],

                                  if (state.momBabyBlock != null && state.momBabyProducts.isNotEmpty) ...[
                                    HomeDynamicBlockSection(
                                      title: isArabic
                                          ? 'العناية بالام والطفل'
                                          : 'Mom & Baby & Child Care',
                                      isArabic: isArabic,
                                      block: state.momBabyBlock!,
                                      products: state.momBabyProducts,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],


                                  if (state.homeCareBlock != null && state.homeCareProducts.isNotEmpty) ...[
                                    HomeDynamicBlockSection(
                                      title: isArabic
                                          ? 'العناية بالمنزل'
                                          : 'Home Care',
                                      isArabic: isArabic,
                                      block: state.homeCareBlock!,
                                      products: state.homeCareProducts,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],

                                  if (state.feminineCareBlock != null &&
                                      state.feminineCareProducts.isNotEmpty) ...[
                                    HomeDynamicBlockSection(
                                      title: isArabic
                                          ? 'العناية النسائية'
                                          : 'Feminine Personal Care',
                                      isArabic: isArabic,
                                      block: state.feminineCareBlock!,
                                      products: state.feminineCareProducts,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],

                                  if (state.menCareBlock != null && state.menCareProducts.isNotEmpty) ...[
                                    HomeDynamicBlockSection(
                                      title: isArabic
                                          ? 'العناية للرجال'
                                          : 'Men Care',
                                      isArabic: isArabic,
                                      block: state.menCareBlock!,
                                      products: state.menCareProducts,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],



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
