import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandStrip extends StatelessWidget {
  const BrandStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> brands = [
      'assets/images/Red_Big_Card.png',
      'assets/images/Red_Big_Card.png',
      'assets/images/Red_Big_Card.png',
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      height: 74.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: brands.map((brand) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Image.asset(
                brand,
                fit: BoxFit.contain,
                height: 28.h,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
