import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/database/favorite_product_model.dart';
import 'package:almasry_2/core/database/favorites_repository.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/features/product_details/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WishlistItemCard extends StatelessWidget {
  final FavoriteProductModel product;
  final VoidCallback onRemoved;

  const WishlistItemCard({
    super.key,
    required this.product,
    required this.onRemoved,
  });

  Future<void> _removeFromWishlist() async {
    await FavoritesRepository.instance.removeFavorite(product.id);
    onRemoved();
  }

  void _openDetails(BuildContext context) {
    context.push(
      AppRoutes.productDetails,
      extra: ProductDetailsArgs(
        productId: product.id,
        imagePath: product.imagePath,
        title: product.title,
        price: product.price,
        oldPrice: product.oldPrice,
        category: product.category,
        description: product.description,
        rating: 3.6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openDetails(context),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFECECEC)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                product.imagePath,
                width: 90.w,
                height: 90.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    product.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    product.price,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.oldPrice,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            InkWell(
              onTap: _removeFromWishlist,
              borderRadius: BorderRadius.circular(50.r),
              child: Container(
                width: 38.w,
                height: 38.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF1F1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite,
                  color: AppColors.primaryRed,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
