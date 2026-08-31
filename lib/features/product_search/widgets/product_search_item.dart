part of '../product_search_imports.dart';

class ProductSearchItem extends StatefulWidget {
  final ProductSearchViewModel vm;
  final ProductSearchProductModel product;

  const ProductSearchItem({super.key, required this.vm, required this.product});

  @override
  State<ProductSearchItem> createState() => _ProductSearchItemState();
}

class _ProductSearchItemState extends State<ProductSearchItem> {
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);

  void _decrement() {
    if (_quantity <= 1) return;
    setState(() => _quantity--);
  }

  Future<void> _addToCart() async {
    await widget.vm._addToCart(sku: widget.product.sku, quantity: _quantity);
  }

  @override
  Widget build(BuildContext context) {
    final ProductSearchProductModel product = widget.product;

    final int? discount = product.discountPercent;

    return CustomAppCard(
      onTap: () => widget.vm._openProductDetails(product),
      shadowOpacity: 0.05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: _imageSection(product)),

          if (discount != null)
            CustomAppDiscountBanner(percent: discount, borderRadius: 0),

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
                      color: AppColors.titleNavy,
                      height: 1.25,
                    ),
                  ),

                  const Spacer(),

                  _priceRow(product),

                  10.verticalSpace,

                  product.isOutOfStock
                      ? CustomAppStatusBanner(label: LocaleKeys.outOfStock.tr())
                      : _cartRow(),
                ],
              ),
            ),
          ),
        ],
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
            child: CustomAppNetworkImage(
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
      GenericCubit<ListFavorites>,
      GenericState<ListFavorites>
    >(
      bloc: widget.vm._favoritesCubit,
      builder: (context, state) {
        return CustomAppFavoriteButton(
          isFavorite: widget.vm._favoritesService.isFavorite(product.sku),
          onTap: () => widget.vm._toggleFavorite(product),
        );
      },
    );
  }

  Widget _priceRow(ProductSearchProductModel product) {
    return CustomAppPriceRow(
      crossAxisAlignment: CrossAxisAlignment.end,
      price:
          '${LocaleKeys.currencyShort.tr()} ${product.finalPrice.toStringAsFixed(2)}',
      oldPrice: product.hasDiscount
          ? '${LocaleKeys.currencyShort.tr()} ${product.regularPrice.toStringAsFixed(2)}'
          : null,
      priceStyle: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.titleNavy,
      ),
    );
  }

  Widget _cartRow() {
    return Row(
      children: [
        _addToCartButton(),

        const Spacer(),

        CustomAppQuantityStepper(
          quantity: _quantity,
          onIncrement: _increment,
          onDecrement: _quantity > 1 ? _decrement : null,
        ),
      ],
    );
  }

  Widget _addToCartButton() {
    return BlocBuilder<GenericCubit<Set<String>>, GenericState<Set<String>>>(
      bloc: widget.vm._addingSkusCubit,
      builder: (context, state) {
        final bool isAdding = state.data.contains(widget.product.sku.trim());
        final bool isEnabled = !isAdding && widget.product.sku.isNotEmpty;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? _addToCart : null,
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 34.w,
              height: 34.h,
              child: Center(
                child: isAdding
                    ? SizedBox(
                        width: 18.w,
                        height: 18.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          color: AppColors.titleNavy,
                        ),
                      )
                    : Icon(
                        Icons.add_shopping_cart_outlined,
                        size: 20.sp,
                        color: AppColors.titleNavy,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
