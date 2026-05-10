import 'package:almasry_2/features/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeProductsSection extends StatelessWidget {
  final bool isArabic;
  final int itemCount;

  const HomeProductsSection({
    super.key,
    required this.isArabic,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: isArabic,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const ProductCard();
        },
      ),
    );
  }
}
