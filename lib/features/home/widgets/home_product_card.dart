part of '../home_imports.dart';

class ProductCard extends StatefulWidget {
  final String sku;
  final String imagePath;
  final String title;
  final String price;
  final String oldPrice;
  final String category;
  final String description;
  final String discountText;
  final String pointsText;
  final double rating;
  final bool isNetworkImage;

  const ProductCard({
    super.key,
    required this.sku,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.description,
    required this.discountText,
    required this.pointsText,
    required this.rating,
    this.isNetworkImage = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}


class _ProductCardState extends State<ProductCard> {
  int quantity = 1;

  Future<void> _toggleFavorite() async {
    final product = FavoriteProductModel(
      id: widget.sku,
      title: widget.title,
      imagePath: widget.imagePath,
      price: widget.price,
      oldPrice: widget.oldPrice,
      category: widget.category,
      description: widget.description,
    );

    await context.read<FavoritesCubit>().toggleFavorite(product);
  }


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
    print('OPEN PRODUCT DETAILS WITH SKU: ${widget.sku}');

    context.push(
      AppRoutes.productDetails,
      extra: ProductDetailsArgs(
        sku: widget.sku,
        title: widget.title,
        imagePath: widget.imagePath,
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  child: widget.isNetworkImage
                      ? Image.network(
                    widget.imagePath,
                    height: 145.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 145.h,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  )
                      : Image.asset(
                    widget.imagePath,
                    height: 145.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, favoritesState) {
                      final isFavorite = favoritesState.isFavorite(
                        widget.sku,
                      );

                      return InkWell(
                        onTap: _toggleFavorite,
                        borderRadius: BorderRadius.circular(50.r),
                        child: Container(
                          width: 34.w,
                          height: 34.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? AppColors.primaryRed
                                : Colors.grey,
                            size: 20.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.h, right: 10.w, left: 10.w),
              child: Text(
                widget.discountText,
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
                widget.title,
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
                widget.price,
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
                    widget.oldPrice,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.pointsText,
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
        child: Icon(icon, size: 18.sp, color: AppColors.textPrimary),
      ),
    );
  }
}
