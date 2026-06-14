part of '../product_list_imports.dart';

class ProductListItem extends StatelessWidget {
  final ProductResponse product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onTap;


  const ProductListItem({
    super.key,
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.onTap,

  });

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
    return product.extensionAttributes?.priceAfter ?? product.price ?? 0;
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: Icon(
                      Icons.favorite_border_rounded,
                      size: 18.sp,
                      color: const Color(0xFF8E8E8E),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: imageUrl.isEmpty
                        ? Icon(
                      Icons.image_not_supported_outlined,
                      size: 42.sp,
                      color: Colors.grey.shade400,
                    )
                        : Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image_not_supported_outlined,
                        size: 42.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                if (discount != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Get a discount $discount%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3B3B3B),
                      ),
                    ),
                  ),
                SizedBox(height: 10.h),
                Text(
                  product.name ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF18314F),
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'L.E ${currentPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF18314F),
                  ),
                ),
                SizedBox(height: 4.h),
                if (oldPrice != null && oldPrice > currentPrice)
                  Text(
                    'L.E ${oldPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                SizedBox(height: 10.h),
                isOutOfStock
                    ? Container(
                  width: double.infinity,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBDBDBD),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Out Of Stock',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                )
                    : Row(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: const Color(0xFF18314F),
                      size: 20.sp,
                    ),
                    const Spacer(),
                    Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: onIncrement,
                            icon: const Icon(Icons.add),
                            visualDensity: VisualDensity.compact,
                          ),
                          Text(
                            '$quantity',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            onPressed: quantity > 1 ? onDecrement : null,
                            icon: const Icon(Icons.remove),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
