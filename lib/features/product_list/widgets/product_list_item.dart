part of '../product_list_imports.dart';

class ProductListItem extends StatelessWidget {
  final ProductListViewModel vm;
  final ProductModel product;

  const ProductListItem({super.key, required this.vm, required this.product});

  String _fullImageUrl() {
    final base = product.extensionAttributes?.urlBase ?? '';
    final thumb = product.extensionAttributes?.thumbnail ?? '';

    if (base.isEmpty || thumb.isEmpty) return '';
    return '$base$thumb';
  }

  num? _oldPrice() {
    return product.extensionAttributes?.priceBefore;
  }

  num _currentPrice() {
    return product.extensionAttributes?.priceAfter ?? product.price;
  }

  int? _discountPercent() {
    final before = _oldPrice();
    final after = _currentPrice();

    if (before == null || before <= 0 || after <= 0 || after >= before) {
      return null;
    }

    final discount = (((before - after) / before) * 100).round();
    return discount > 0 ? discount : null;
  }

  /// The wishlist stores a flat snapshot rather than a product reference, so
  /// the derived values above are what get written. Prices go in bare, the way
  /// the other grids store them — the currency label is added on read.
  FavoriteProductModel _favoriteProduct(String imageUrl) {
    final num? oldPrice = _oldPrice();
    final num currentPrice = _currentPrice();

    return FavoriteProductModel(
      id: product.sku,
      title: product.name,
      imagePath: imageUrl,
      price: currentPrice.toStringAsFixed(2),
      oldPrice: oldPrice != null && oldPrice > currentPrice
          ? oldPrice.toStringAsFixed(2)
          : '',
      category: '',
      description: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _fullImageUrl();
    final currentPrice = _currentPrice();
    final oldPrice = _oldPrice();
    final discount = _discountPercent();

    // `ProductModel.isInStock`, not a local rule: the home cards read the same
    // getter, and this grid used to disagree with them on the same product.
    final isOutOfStock = !product.isInStock;

    final sku = product.sku;
    final quantity = vm._getProductQuantity(sku);

    return CustomAppCard(
      onTap: () => vm._navToProductDetails(product),
      padding: EdgeInsets.all(10.w),
      shadowOpacity: 0.05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: BlocBuilder<
              GenericCubit<FavoritesModel>,
              GenericState<FavoritesModel>
            >(
              bloc: vm._favoritesCubit,
              builder: (context, state) {
                return CustomAppFavoriteButton(
                  isFavorite: state.data.isFavorite(sku),
                  onTap: sku.isEmpty
                      ? null
                      : () => vm._toggleFavorite(_favoriteProduct(imageUrl)),
                );
              },
            ),
          ),
          6.verticalSpace,
          Expanded(
            flex: 4,
            child: Center(
              child: CustomAppNetworkImage(
                url: imageUrl,
                fit: BoxFit.contain,
                placeholder: Icon(
                  Icons.image_not_supported_outlined,
                  size: 42.sp,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          8.verticalSpace,
          if (discount != null) CustomAppDiscountBanner(percent: discount),
          10.verticalSpace,
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
          10.verticalSpace,
          CustomAppPriceRow(
            axis: Axis.vertical,
            spacing: 4,
            price:
                '${LocaleKeys.currencyShort.tr()} ${currentPrice.toStringAsFixed(2)}',
            oldPrice: oldPrice != null && oldPrice > currentPrice
                ? '${LocaleKeys.currencyShort.tr()} ${oldPrice.toStringAsFixed(2)}'
                : null,
            priceStyle: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.titleNavy,
            ),
            oldPriceStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          10.verticalSpace,
          if (isOutOfStock)
            CustomAppStatusBanner(label: LocaleKeys.outOfStock.tr())
          else
            Row(
              children: [
                // Per sku, so only this card spins — the cubit is shared by the
                // whole grid. A second tap on the same card is still ignored
                // while its own add is in flight.
                BlocBuilder<GenericCubit<CartData>, GenericState<CartData>>(
                  bloc: vm._cartCubit,
                  builder: (context, state) {
                    final bool isAdding = state.data.isAddingSku(sku);
                    final bool isEnabled = !isAdding && sku.isNotEmpty;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isEnabled ? () => vm._addToCart(sku) : null,
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
                                    Icons.shopping_cart_outlined,
                                    color: AppColors.titleNavy,
                                    size: 20.sp,
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                CustomAppQuantityStepper(
                  quantity: quantity,
                  height: 40,
                  buttonSize: 34,
                  iconSize: 20,
                  spacing: 4,
                  contentColor: Colors.black87,
                  onIncrement: sku.isEmpty
                      ? null
                      : () => vm._incrementQuantity(sku),
                  onDecrement: quantity > 1 && sku.isNotEmpty
                      ? () => vm._decrementQuantity(sku)
                      : null,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
