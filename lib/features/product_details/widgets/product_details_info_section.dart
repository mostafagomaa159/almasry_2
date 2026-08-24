part of '../product_details_imports.dart';

/// The "Information" table. Rows now come from the backend's own
/// `custom_attributes` — label included — so a new attribute appears without a
/// code change, and the hardcoded attribute-code list is gone.
class ProductDetailsInfoSection extends StatelessWidget {
  final ProductDetailModel product;

  const ProductDetailsInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final List<_ProductInfoItem> attributes = _buildAttributes();

    if (attributes.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.productDetailsInfo.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.navyHeading,
            ),
          ),

          14.verticalSpace,

          ...attributes.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _ProductInfoRow(item: item),
            ),
          ),
        ],
      ),
    );
  }

  List<_ProductInfoItem> _buildAttributes() {
    final List<_ProductInfoItem> items = [
      _ProductInfoItem(
        label: LocaleKeys.productDetailsCategories.tr(),
        value: product.categories
            .map((category) => category.name)
            .where((name) => name.trim().isNotEmpty)
            .join(', '),
      ),

      _ProductInfoItem(
        label: LocaleKeys.attrBrand.tr(),
        value: product.brandName,
        highlightValue: true,
      ),

      ...product.customAttributes.map(
        (ProductCustomAttributeModel attribute) => _ProductInfoItem(
          label: attribute.label,
          value: attribute.displayValue,
        ),
      ),

      _ProductInfoItem(
        label: LocaleKeys.productDetailsCountry.tr(),
        value: product.countryOfManufacture,
      ),

      _ProductInfoItem(
        label: LocaleKeys.productDetailsWeight.tr(),
        value: product.weight == null ? '' : '${product.weight}',
      ),
    ];

    return items.where((item) => item.value.trim().isNotEmpty).toList();
  }
}

class _ProductInfoItem {
  final String label;
  final String value;
  final bool highlightValue;

  const _ProductInfoItem({
    required this.label,
    required this.value,
    this.highlightValue = false,
  });
}

class _ProductInfoRow extends StatelessWidget {
  final _ProductInfoItem item;

  const _ProductInfoRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.borderInfoRow),
      ),
      child: IntrinsicHeight(
        // Label first, so it sits on the leading edge in both directions: on
        // the right in Arabic, on the left in English. Ordering the value
        // first put each column on the wrong side of the row in *both*
        // locales, since a Row lays its children out along the ambient
        // direction rather than a fixed one.
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                child: CustomAppDirectionalText(
                  '${item.label}:',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                    color: AppColors.textInfoValue,
                  ),
                ),
              ),
            ),

            Container(width: 1, color: AppColors.borderInfoRow),

            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                child: CustomAppDirectionalText(
                  item.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: item.highlightValue
                        ? AppColors.redHeading
                        : AppColors.textInfoMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
