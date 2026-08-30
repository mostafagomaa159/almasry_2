part of '../home_imports.dart';

class HomeBannerSlider extends StatelessWidget {
  final HomeViewModel vm;

  const HomeBannerSlider({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final banners = vm._data().banners;
    final currentIndex = vm._data().currentBannerIndex;

    if (banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 165.h,
          child: PageView.builder(
            controller: vm._bannerController,
            onPageChanged: vm._changeBannerIndex,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22.r),
                  child: CustomAppNetworkImage(
                    url: banner.image,
                    width: double.infinity,
                    showLoader: true,
                    placeholder: Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        8.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => Container(
              width: currentIndex == index ? 14.w : 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? AppColors.primaryRed
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
