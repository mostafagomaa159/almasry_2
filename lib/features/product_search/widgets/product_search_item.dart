part of '../product_search_imports.dart';

/// One result card: image with its badge and favourite button, the discount
/// strip, name, price, and either the quantity stepper or the out-of-stock
/// banner.
class ProductSearchItem extends StatefulWidget {
  final ProductSearchViewModel vm;
  final ProductSearchProductModel product;

  const ProductSearchItem({super.key, required this.vm, required this.product});

  @override
  State<ProductSearchItem> createState() => _ProductSearchItemState();
}

class _ProductSearchItemState extends State<ProductSearchItem> {
  static const Color _titleColor = Color(0xFF18314F);
  static const Color _stripColor = Color(0xFFEDEDED);
  static const Color _outOfStockColor = Color(0xFFBDBDBD);

  /// The card's own counter — nothing outside it reads the number until a cart
  /// endpoint exists, so it stays view-local.
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);

  void _decrement() {
    if (_quantity <= 1) return;
    setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final ProductSearchProductModel product = widget.product;

    final int? discount = product.discountPercent;
    final BorderRadius radius = BorderRadius.circular(16.r);

    return Material(
      color: AppColors.white,
      borderRadius: radius,
      child: InkWell(
        onTap: () => widget.vm._openProductDetails(product),
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: _imageSection(product)),

              if (discount != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  color: _stripColor,
                  child: Text(
                    LocaleKeys.getDiscount.tr(args: ['$discount']),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3B3B3B),
                    ),
                  ),
                ),

              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: _titleColor,
                          height: 1.25,
                        ),
                      ),

                      const Spacer(),

                      _priceRow(product),

                      10.verticalSpace,

                      product.isOutOfStock ? _outOfStockBanner() : _cartRow(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSection(ProductSearchProductModel product) {
    final ProductSearchLabelModel? label = product.primaryLabel;

    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Stack(
        children: [
          Positioned.fill(
            child: AppNetworkImage(
              url: product.imageUrl,
              fit: BoxFit.contain,
              placeholder: Icon(
                Icons.image_not_supported_outlined,
                size: 42.sp,
                color: Colors.grey.shade400,
              ),
            ),
          ),

          if (label != null)
            PositionedDirectional(
              start: 0,
              top: 0,
              child: ProductSearchLabelBadge(label: label),
            ),

          PositionedDirectional(
            end: 0,
            top: 0,
            child: _favoriteButton(product),
          ),
        ],
      ),
    );
  }

  Widget _favoriteButton(ProductSearchProductModel product) {
    return BlocBuilder<
      GenericCubit<FavoritesModel>,
      GenericState<FavoritesModel>
    >(
      bloc: widget.vm._favoritesCubit,
      builder: (context, state) {
        final bool isFavorite = state.data.isFavorite(product.sku);

        return Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          child: InkWell(
            onTap: () => widget.vm._toggleFavorite(product),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 32.w,
              height: 32.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFEAEAEA)),
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                size: 18.sp,
                color: isFavorite
                    ? AppColors.primaryRed
                    : const Color(0xFF8E8E8E),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _priceRow(ProductSearchProductModel product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${LocaleKeys.currencyShort.tr()} ${product.finalPrice.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
            color: _titleColor,
          ),
        ),

        if (product.hasDiscount) ...[
          6.horizontalSpace,
          Flexible(
            child: Text(
              '${LocaleKeys.currencyShort.tr()} ${product.regularPrice.toStringAsFixed(2)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _outOfStockBanner() {
    return Container(
      width: double.infinity,
      height: 40.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _outOfStockColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        LocaleKeys.outOfStock.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _cartRow() {
    return Row(
      children: [
        Icon(Icons.add_shopping_cart_outlined, size: 20.sp, color: _titleColor),

        const Spacer(),

        Container(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _stepperButton(icon: Icons.add, onTap: _increment),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  '$_quantity',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: _titleColor,
                  ),
                ),
              ),
              _stepperButton(
                icon: Icons.remove,
                onTap: _quantity > 1 ? _decrement : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: 26.w,
          height: 26.w,
          child: Icon(
            icon,
            size: 17.sp,
            color: onTap == null ? const Color(0xFFD0D0D0) : _titleColor,
          ),
        ),
      ),
    );
  }
}
