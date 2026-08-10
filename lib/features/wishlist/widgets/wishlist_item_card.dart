part of '../wishlist_imports.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistViewModel vm;
  final FavoriteProductModel product;

  const WishlistItemCard({super.key, required this.vm, required this.product});

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  Widget _buildImage(BuildContext context) {
    final imagePath = product.imagePath.trim();

    if (imagePath.isEmpty) {
      return _imagePlaceholder();
    }

    if (_isNetworkImage(imagePath)) {
      return AppNetworkImage(
        url: imagePath,
        width: 90.w,
        height: 90.h,
        placeholder: _imagePlaceholder(),
      );
    }

    return Image.asset(
      imagePath,
      width: 90.w,
      height: 90.h,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 90.w,
      height: 90.h,
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
        size: 24.sp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => vm._openDetails(product),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: _buildImage(context),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                  8.verticalSpace,
                  Text(
                    product.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    product.price,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    product.oldPrice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
            8.horizontalSpace,
            InkWell(
              onTap: () => vm._removeFromWishlist(product.id),
              borderRadius: BorderRadius.circular(50.r),
              child: Container(
                width: 38.w,
                height: 38.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF1F1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
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
