part of '../checkout_review_imports.dart';

/// "Your products" — the cart lines, read-only. No stepper here: quantities
/// are changed in the cart, not on the way to paying.
class CheckoutReviewProductsSection extends StatelessWidget {
  final CheckoutReviewViewModel vm;
  final CheckoutReviewData data;
  final CartModel cart;

  const CheckoutReviewProductsSection({
    super.key,
    required this.vm,
    required this.data,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return CheckoutReviewSection(
      title: LocaleKeys.checkoutYourProducts.tr(),
      isExpanded: data.isProductsExpanded,
      onToggle: vm._toggleProducts,
      child: Column(
        children: <Widget>[
          for (final CartItemModel item in cart.items)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: _ProductRow(item: item),
            ),
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final CartItemModel item;

  const _ProductRow({required this.item});

  static const Color _accent = AppColors.darkBlue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: SizedBox(
            width: 66.w,
            height: 66.w,
            child: CustomAppNetworkImage(url: item.imageUrl),
          ),
        ),

        12.horizontalSpace,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: _accent,
                ),
              ),

              10.verticalSpace,

              Text(
                formatPrice(item.unitPrice),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: _accent,
                ),
              ),
            ],
          ),
        ),

        10.horizontalSpace,

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '${item.quantity}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),

            14.verticalSpace,

            Text(
              formatPrice(item.rowTotal),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: _accent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
