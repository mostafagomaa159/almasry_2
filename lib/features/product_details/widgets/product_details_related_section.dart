part of '../product_details_imports.dart';

/// "More From This Brand" — the brand's other products, fetched separately.
/// Falls back to the curated related/upsell/cross-sell sets when the product
/// carries no brand id. Tapping a card reopens this screen on that SKU.
class ProductDetailsRelatedSection extends StatelessWidget {
  final ProductDetailsViewModel vm;
  final ProductDetailModel product;

  const ProductDetailsRelatedSection({
    super.key,
    required this.vm,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final List<ProductRelatedItemModel> brandProducts = vm._data.brandProducts;

    final List<ProductRelatedItemModel> items = brandProducts.isNotEmpty
        ? brandProducts
        : product.carouselProducts;

    if (items.isEmpty) {
      return vm._data.isBrandProductsLoading
          ? const _RelatedShimmer()
          : const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            LocaleKeys.productDetailsMoreFromBrand.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.navyHeading,
            ),
          ),
        ),

        14.verticalSpace,

        SizedBox(
          height: 250.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: items.length,
            separatorBuilder: (context, index) => 12.horizontalSpace,
            itemBuilder: (context, index) {
              return _RelatedCard(vm: vm, item: items[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _RelatedShimmer extends StatelessWidget {
  const _RelatedShimmer();

  @override
  Widget build(BuildContext context) {
    return CustomAppShimmer(
      child: SizedBox(
        height: 250.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: 3,
          separatorBuilder: (context, index) => 12.horizontalSpace,
          itemBuilder: (context, index) {
            return Container(
              width: 150.w,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RelatedCard extends StatelessWidget {
  const _RelatedCard({required this.vm, required this.item});

  final ProductDetailsViewModel vm;
  final ProductRelatedItemModel item;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(14.r);

    return Material(
      color: AppColors.white,
      borderRadius: radius,
      child: InkWell(
        onTap: () => vm._openRelatedProduct(item),
        borderRadius: radius,
        child: Container(
          width: 150.w,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: CustomAppNetworkImage(
                    url: item.thumbnailUrl,
                    fit: BoxFit.contain,
                    placeholder: Icon(
                      Icons.image_not_supported_outlined,
                      size: 32.sp,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),

              10.verticalSpace,

              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navyHeading,
                  height: 1.3,
                ),
              ),

              8.verticalSpace,

              Text(
                vm._formatPrice(item.finalPrice.value),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navyHeading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
