import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/features/product_details/product_details.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _openProductDetails() {
    context.push(
      AppRoutes.productDetails,
      extra: ProductDetailsArgs(
        imagePath: 'assets/images/Red_Big_Card.png',
        title: LocaleKeys.homeProductTitle.tr(),
        price: LocaleKeys.homePrice.tr(),
        category: LocaleKeys.productDetailsCategoryWomenClothing.tr(),
        description: LocaleKeys.productDetailsDescriptionValue.tr(),
        rating: 3.6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openProductDetails,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 175.w,
        margin: EdgeInsetsDirectional.only(start: 10.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFEDEDED)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: Image.asset(
                'assets/images/Red_Big_Card.png',
                height: 145.h,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.h, right: 10.w, left: 10.w),
              child: Text(
                LocaleKeys.homeDiscountBadge.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.h, right: 10.w, left: 10.w),
              child: Text(
                LocaleKeys.homeProductTitle.tr(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.h, right: 10.w, left: 10.w),
              child: Text(
                LocaleKeys.homePrice.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Text(
                    LocaleKeys.homeOldPrice.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    LocaleKeys.homePoints.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: AppColors.primaryRed,
                    size: 22.sp,
                  ),
                  const Spacer(),
                  _buildCircleButton(
                    icon: Icons.add,
                    onTap: _incrementQuantity,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    '$quantity',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  _buildCircleButton(
                    icon: Icons.remove,
                    onTap: _decrementQuantity,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50.r),
      child: Container(
        width: 30.w,
        height: 30.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18.sp,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
