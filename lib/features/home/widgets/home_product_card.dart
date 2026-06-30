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
  static const Color _titleColor = Color(0xFF183B61);
  static const Color _mutedColor = Color(0xFF4A4A4A);
  static const Color _borderColor = Color(0xFFEDEDED);
  static const Color _softBorderColor = Color(0xFFE1E1E1);
  static const Color _disabledBgColor = Color(0xFFF7F7F7);
  static const Color _disabledBorderColor = Color(0xFFF0F0F0);
  static const Color _disabledIconColor = Color(0xFFD0D0D0);

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

    await sl<FavoritesViewModel>().toggleFavorite(product);
  }

  void _incrementQuantity() {
    setState(() => quantity++);
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() => quantity--);
    }
  }

  void _openProductDetails() {
    context.pushNamed(
      'productDetails',
      extra: ProductDetailsArgs(
        sku: widget.sku,
        title: widget.title,
        imagePath: widget.imagePath,
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    final bool hasOldPrice = widget.oldPrice.trim().isNotEmpty;
    final bool hasDiscount = widget.discountText.trim().isNotEmpty;

    final radius = BorderRadius.circular(16.r);

    return Container(
      width: 165.w,
      margin: EdgeInsetsDirectional.only(start: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              onTap: _openProductDetails,
              borderRadius: radius,
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 130.h,
                            width: double.infinity,
                            child: Center(
                              child: widget.isNetworkImage
                                  ? Image.network(
                                widget.imagePath,
                                height: 110.h,
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return Container(
                                    height: 100.h,
                                    width: 100.w,
                                    color: Colors.grey.shade100,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      color: Colors.grey,
                                      size: 26.sp,
                                    ),
                                  );
                                },
                              )
                                  : Image.asset(
                                widget.imagePath,
                                height: 110.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: BlocBuilder<
                                GenericCubit<FavoritesModel>,
                                GenericState<FavoritesModel>>(
                              builder: (context, state) {
                                final isFavorite =
                                state.data.isFavorite(widget.sku);

                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _toggleFavorite,
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Container(
                                      width: 32.w,
                                      height: 32.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10.r),
                                        border: Border.all(
                                          color: const Color(0xFFEAEAEA),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.04,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? AppColors.primaryRed
                                            : const Color(0xFFC8C8C8),
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        hasDiscount ? widget.discountText : '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: _mutedColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: 6.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                          color: _titleColor,
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.price,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: _titleColor,
                            ),
                          ),
                          if (hasOldPrice) ...[
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Text(
                                widget.oldPrice,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFFBDBDBD),
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // add cart/remove action here
                    },
                    borderRadius: BorderRadius.circular(8.r),
                    child: SizedBox(
                      width: 28.w,
                      height: 28.h,
                      child: Icon(
                        Icons.add_shopping_cart_outlined,
                        size: 19.sp,
                        color: _mutedColor,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                _buildQuantityStepper(),
              ],
            ),
          ),

          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildQuantityStepper() {
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _softBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQtyButton(
            icon: Icons.remove,
            onTap: quantity > 1 ? _decrementQuantity : null,
            isDisabled: quantity == 1,
          ),
          SizedBox(width: 12.w),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 12.w),
            child: Center(
              child: Text(
                '$quantity',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: _titleColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          _buildQtyButton(
            icon: Icons.add,
            onTap: _incrementQuantity,
            isDisabled: false,
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isDisabled,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: 24.w,
          height: 24.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDisabled ? _disabledBgColor : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isDisabled
                  ? _disabledBorderColor
                  : const Color(0xFFE6E6E6),
            ),
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: isDisabled ? _disabledIconColor : _mutedColor,
          ),
        ),
      ),
    );
  }
}
