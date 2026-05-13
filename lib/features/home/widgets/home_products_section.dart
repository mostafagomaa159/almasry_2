import 'package:almasry_2/features/home/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/core.dart';

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
          return  ProductCard(
            productId: 'product_1',
            imagePath: 'assets/images/Red_Big_Card.png',
            title: LocaleKeys.homeProductTitle.tr(),
            price: LocaleKeys.homePrice.tr(),
            oldPrice: LocaleKeys.homeOldPrice.tr(),
            category: LocaleKeys.productDetailsCategoryWomenClothing.tr(),
            description: LocaleKeys.productDetailsDescriptionValue.tr(),
            discountText: LocaleKeys.homeDiscountBadge.tr(),
            pointsText: LocaleKeys.homePoints.tr(),
            rating: 3.6,
          );

        },
      ),
    );
  }
}
