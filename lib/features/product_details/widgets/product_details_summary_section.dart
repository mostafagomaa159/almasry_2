part of '../product_details_imports.dart';

class ProductDetailsSummarySection extends StatelessWidget {
  final ProductDetailsViewModel vm;
  final ProductDetailModel product;

  const ProductDetailsSummarySection({
    super.key,
    required this.vm,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final String oldPrice = product.hasDiscount
        ? vm._formatPrice(product.regularPrice)
        : '';

    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (product.brandName.trim().isNotEmpty)
                Expanded(
                  child: Text(
                    product.brandName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.redHeading,
                    ),
                  ),
                )
              else
                const Spacer(),

              if (product.sku.trim().isNotEmpty)
                Text(
                  '#${product.sku}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDisabled,
                  ),
                ),
            ],
          ),

          10.verticalSpace,

          Text(
            vm._title(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.navyHeading,
              height: 1.45,
            ),
          ),

          12.verticalSpace,

          Row(
            children: [
              _StockBadge(product: product),

              if (product.discountPercent > 0) ...[
                8.horizontalSpace,
                _DiscountBadge(percent: product.discountPercent),
              ],
            ],
          ),

          if (product.isInStock && product.onlyXLeftInStock != null) ...[
            8.verticalSpace,
            Text(
              LocaleKeys.productDetailsOnlyXLeft.tr(
                args: ['${product.onlyXLeftInStock!.round()}'],
              ),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.amber,
              ),
            ),
          ],

          12.verticalSpace,

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                vm._formatPrice(product.finalPrice),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navyHeading,
                ),
              ),

              if (oldPrice.isNotEmpty) ...[
                12.horizontalSpace,
                Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: Text(
                    oldPrice,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    final bool isInStock = product.isInStock;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isInStock ? AppColors.successGreen : AppColors.primaryRed,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        isInStock
            ? LocaleKeys.productDetailsInStock.tr()
            : LocaleKeys.productDetailsOutOfStock.tr(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.borderSoft,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        LocaleKeys.getDiscount.tr(args: ['$percent']),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.strongGrey,
        ),
      ),
    );
  }
}
