part of '../home_imports.dart';

class HomeView extends StatefulWidget {
  final ProfileArgs? args;

  const HomeView({super.key, this.args});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final PageController bannerController;
  late final HomeViewModel viewModel;
  Timer? bannerTimer;

  @override
  void initState() {
    super.initState();
    bannerController = PageController();
    viewModel = HomeViewModel()..init();
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
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return BlocConsumer<
        GenericCubit<HomeModel>,
        GenericState<HomeModel>>(
      bloc: viewModel.homeCubit,
      listener: (context, state) {
        final data = state.data;

        if (data.banners.isNotEmpty) {
          _startBannerAutoSlide(data.banners.length);
        } else {
          bannerTimer?.cancel();
        }
      },
      builder: (context, state) {
        final data = state.data;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),
          bottomNavigationBar: HomeBottomNavBar(
            selectedIndex: data.selectedBottomNavIndex,
            cartCount: 10,
            onTap: (index) {
              switch (index) {
                case 0:
                  viewModel.changeBottomNavIndex(index);
                  break;
                case 1:
                  context.push(AppRoutes.categories);
                  break;
                case 2:
                  viewModel.changeBottomNavIndex(index);
                  break;
                case 3:
                  viewModel.changeBottomNavIndex(index);
                  break;
                case 4:
                  context.push(AppRoutes.profile, extra: widget.args);
                  break;
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
                      if (data.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (data.errorMessage != null &&
                          data.errorMessage!.isNotEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              data.errorMessage!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: viewModel.getHomeData,
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
                                    onPageChanged: viewModel.changeBannerIndex,
                                    banners: data.banners,
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
                                          iconPath: AppImages.mask,
                                          backgroundColor: const Color(0xFFFDEBEC),
                                          onTap: () {},
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: HomeQuickActionCard(
                                          title: isArabic
                                              ? 'البحث الذكي'
                                              : 'Smart Search',
                                          iconPath: AppImages.ai,
                                          backgroundColor: const Color(0xFFF3F0FF),
                                          onTap: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 24.h),

                                if (data.offers.isNotEmpty) ...[
                                  HomeSectionHeader(
                                    title: LocaleKeys.homeOffers.tr(),
                                  ),
                                  SizedBox(height: 14.h),
                                  HomeOffersSection(
                                    isArabic: isArabic,
                                    items: data.offers,
                                  ),
                                  SizedBox(height: 24.h),
                                ],

                                if (data.categories.isNotEmpty) ...[
                                  HomeSectionHeader(
                                    title: LocaleKeys.homeCategories.tr(),
                                  ),
                                  SizedBox(height: 12.h),
                                  HomeCategoriesSection(
                                    isArabic: isArabic,
                                    items: data.categories,
                                  ),
                                  SizedBox(height: 24.h),
                                ],

                                if (data.bestSellerBlock != null) ...[
                                  HomeSectionHeader(
                                    title: LocaleKeys.homeBestSelling.tr(),
                                  ),
                                  SizedBox(height: 16.h),

                                  if (data.bestSellerProducts.isEmpty)
                                    const Center(child: Text('No bestseller products')),

                                  if (data.bestSellerProducts.isNotEmpty)
                                    HomeProductsSection(
                                      isArabic: isArabic,
                                      products: data.bestSellerProducts,
                                    ),

                                  SizedBox(height: 24.h),
                                ],

                                if (data.brands.isNotEmpty) ...[
                                  HomeSectionHeader(
                                    title: isArabic ? 'العلامات التجارية' : 'Brands',
                                  ),
                                  SizedBox(height: 12.h),
                                  BrandStrip(
                                    brands: data.brands,
                                  ),
                                  SizedBox(height: 24.h),
                                ],

                                if (data.goals.isNotEmpty) ...[
                                  HomeSectionHeader(
                                    title: LocaleKeys.homeGoals.tr(),
                                  ),
                                  SizedBox(height: 12.h),
                                  HomeGoalsSection(
                                    isArabic: isArabic,
                                    items: data.goals,
                                  ),
                                  SizedBox(height: 24.h),
                                ],

                                if (data.concerns.isNotEmpty) ...[
                                  HomeSectionHeader(
                                    title: LocaleKeys.homeConcerns.tr(),
                                  ),
                                  SizedBox(height: 12.h),
                                  HomeConcernsSection(
                                    isArabic: isArabic,
                                    items: data.concerns,
                                  ),
                                  SizedBox(height: 24.h),
                                ],

                                if (data.momBabyBlock != null &&
                                    data.momBabyProducts.isNotEmpty) ...[
                                  HomeDynamicBlockSection(
                                    title: isArabic
                                        ? 'العناية بالام والطفل'
                                        : 'Mom & Baby & Child Care',
                                    isArabic: isArabic,
                                    block: data.momBabyBlock!,
                                    products: data.momBabyProducts,
                                  ),
                                  SizedBox(height: 24.h),
                                ],

                                if (data.homeCareBlock != null &&
                                    data.homeCareProducts.isNotEmpty) ...[
                                  HomeDynamicBlockSection(
                                    title: isArabic
                                        ? 'العناية بالمنزل'
                                        : 'Home Care',
                                    isArabic: isArabic,
                                    block: data.homeCareBlock!,
                                    products: data.homeCareProducts,
                                  ),
                                  SizedBox(height: 24.h),
                                ],

                                if (data.feminineCareBlock != null &&
                                    data.feminineCareProducts.isNotEmpty) ...[
                                  HomeDynamicBlockSection(
                                    title: isArabic
                                        ? 'العناية النسائية'
                                        : 'Feminine Personal Care',
                                    isArabic: isArabic,
                                    block: data.feminineCareBlock!,
                                    products: data.feminineCareProducts,
                                  ),
                                  SizedBox(height: 24.h),
                                ],

                                if (data.menCareBlock != null &&
                                    data.menCareProducts.isNotEmpty) ...[
                                  HomeDynamicBlockSection(
                                    title: isArabic
                                        ? 'العناية للرجال'
                                        : 'Men Care',
                                    isArabic: isArabic,
                                    block: data.menCareBlock!,
                                    products: data.menCareProducts,
                                  ),
                                  SizedBox(height: 24.h),
                                ],
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
    );
  }
}
