part of '../product_details_imports.dart';

/// The main image with the floating action rail, and the gallery thumbnails
/// under it. Selection lives in the ViewModel, so a refresh resets it.
class ProductDetailsImageSection extends StatelessWidget {
  final ProductDetailsViewModel vm;
  final ProductDetailModel product;

  const ProductDetailsImageSection({
    super.key,
    required this.vm,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> images = vm._galleryImages;

    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
      child: Column(
        children: [
          SizedBox(
            height: 320.h,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: CustomAppNetworkImage(
                      url: vm._selectedImage,
                      height: 250.h,
                      fit: BoxFit.contain,
                      showLoader: true,
                      placeholder: const _ImagePlaceholder(),
                    ),
                  ),
                ),

                PositionedDirectional(
                  end: 0,
                  top: 48.h,
                  child: Column(
                    children: [
                      _ActionButton(icon: Icons.share_outlined, onTap: () {}),
                      12.verticalSpace,
                      _ActionButton(icon: Icons.chat_outlined, onTap: () {}),
                      12.verticalSpace,
                      _FavoriteButton(vm: vm, product: product),
                    ],
                  ),
                ),

                PositionedDirectional(
                  start: 0,
                  top: 110.h,
                  child: _ActionButton(
                    icon: Icons.balance_outlined,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),

          if (images.length > 1) ...[
            8.verticalSpace,
            _GalleryThumbnails(vm: vm, images: images),
          ],

          18.verticalSpace,
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
        ],
      ),
    );
  }
}

class _GalleryThumbnails extends StatelessWidget {
  const _GalleryThumbnails({required this.vm, required this.images});

  final ProductDetailsViewModel vm;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final int selected = vm._selectedImageIndex;

    return SizedBox(
      height: 74.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (context, index) => 10.horizontalSpace,
        itemBuilder: (context, index) {
          final bool isSelected = index == selected;

          return GestureDetector(
            onTap: () => vm._selectImage(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 74.w,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.navyHeading
                      : AppColors.borderThumbnail,
                  width: isSelected ? 1.4 : 1,
                ),
              ),
              child: CustomAppNetworkImage(
                url: images[index],
                fit: BoxFit.contain,
                placeholder: const _ImagePlaceholder(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.vm, required this.product});

  final ProductDetailsViewModel vm;
  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<FavoritesModel>,
      GenericState<FavoritesModel>
    >(
      bloc: vm._favoritesCubit,
      builder: (context, state) {
        final bool isFavorite = state.data.isFavorite(product.sku);

        return _ActionButton(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          iconColor: isFavorite ? AppColors.primaryRed : AppColors.textInk,
          onTap: vm._toggleFavorite,
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceAction,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 22.sp, color: iconColor ?? AppColors.textInk),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfacePlaceholder,
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 34.sp,
        color: AppColors.textSecondary,
      ),
    );
  }
}
