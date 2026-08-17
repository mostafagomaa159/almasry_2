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
      return CustomAppNetworkImage(
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
    return CustomAppCard(
      onTap: () => vm._openDetails(product),
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(12.w),
      borderRadius: 14,
      borderColor: AppColors.borderWishlist,
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
                CustomAppPriceRow(
                  axis: Axis.vertical,
                  spacing: 4,
                  price: product.price,
                  // Non-null even when blank: the model stores an empty string
                  // for "no old price" and the row is kept either way.
                  oldPrice: product.oldPrice,
                  priceStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryRed,
                  ),
                  oldPriceStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          8.horizontalSpace,
          CustomAppFavoriteButton(
            isFavorite: true,
            onTap: () => vm._removeFromWishlist(product.id),
            size: 38,
            iconSize: 20,
            isCircle: true,
            backgroundColor: AppColors.redTintSurface,
            borderColor: null,
          ),
        ],
      ),
    );
  }
}
