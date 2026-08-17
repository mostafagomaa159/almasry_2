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

  bool _isOutOfStock() {
    final stock = product.extensionAttributes?.stockStatus.toLowerCase() ?? '';
    final qty =
        int.tryParse(product.extensionAttributes?.sellableQuantity ?? '0') ?? 0;

    return stock.contains('out') || qty <= 0;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _fullImageUrl();
    final currentPrice = _currentPrice();
    final oldPrice = _oldPrice();
    final discount = _discountPercent();
    final isOutOfStock = _isOutOfStock();

    final sku = product.sku;
    final quantity = vm._getProductQuantity(sku);

    return CustomAppCard(
      onTap: () => vm._navToProductDetails(product),
      padding: EdgeInsets.all(10.w),
      shadowOpacity: 0.05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: AlignmentDirectional.topEnd,
            // Static for now: this grid has no favourites wiring yet, so the
            // heart reports the unset state and swallows nothing.
            child: CustomAppFavoriteButton(isFavorite: false),
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
                Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.titleNavy,
                  size: 20.sp,
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
