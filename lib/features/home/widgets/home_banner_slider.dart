part of '../home_imports.dart';

class HomeBannerSlider extends StatelessWidget {
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final List<HomeSliderItemResponse> banners;

  const HomeBannerSlider({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 165.h,
          child: PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22.r),
                  child: Image.network(
                    banner.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
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
