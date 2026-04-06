import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBannerSlider extends StatelessWidget {
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const HomeBannerSlider({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> banners = [
      'assets/images/Red_Big_Card.png',
      'assets/images/Red_Big_Card.png',
      'assets/images/Red_Big_Card.png',
    ];

    return Column(
      children: [
        SizedBox(
          height: 165.h,
          child: PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22.r),
                  child: Image.asset(
                    banners[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
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
