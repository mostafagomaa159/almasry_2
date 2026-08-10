part of '../product_details_imports.dart';

class ProductDetailsInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final attributes = _buildAttributes(product);

    if (attributes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.productDetailsInfo.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF11385B),
            ),
          ),
          14.verticalSpace,
          ...attributes.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _ProductInfoRow(
                label: item.label,
                value: item.value,
                highlightValue: item.highlightValue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_ProductInfoItem> _buildAttributes(ProductModel product) {
    final items = <_ProductInfoItem>[
      _ProductInfoItem(
        label: LocaleKeys.attrBrand.tr(),
        value: _getCustomAttributeValue(product, 'brand'),
        highlightValue: true,
      ),
      _ProductInfoItem(
        label: LocaleKeys.attrCompanyName.tr(),
        value: _getCustomAttributeValue(product, 'manufacturer'),
      ),
      _ProductInfoItem(
        label: LocaleKeys.attrProductForm.tr(),
        value: _getCustomAttributeValue(product, 'product_form'),
      ),
      _ProductInfoItem(
        label: LocaleKeys.attrBarcode.tr(),
        value: _getCustomAttributeValue(product, 'barcode'),
      ),
      _ProductInfoItem(
        label: LocaleKeys.attrProductType.tr(),
        value: _getCustomAttributeValue(product, 'product_type'),
      ),
      _ProductInfoItem(
        label: LocaleKeys.attrGender.tr(),
        value: _getCustomAttributeValue(product, 'gender'),
      ),
      _ProductInfoItem(
        label: LocaleKeys.attrIngredients.tr(),
        value: _getCustomAttributeValue(product, 'ingredients'),
      ),
      _ProductInfoItem(
        label: LocaleKeys.attrShopByGoal.tr(),
        value: _getCustomAttributeValue(product, 'shop_by_goal'),
      ),
      _ProductInfoItem(
        label: LocaleKeys.attrSpecialties.tr(),
        value: _getCustomAttributeValue(product, 'specialties'),
      ),
      _ProductInfoItem(
        label: LocaleKeys.attrWarnings.tr(),
        value: _getCustomAttributeValue(product, 'warnings'),
      ),
      _ProductInfoItem(
        label: LocaleKeys.attrShopByConcern.tr(),
        value: _getCustomAttributeValue(product, 'shop_by_concern'),
      ),
      _ProductInfoItem(
        label: LocaleKeys.attrColor.tr(),
        value: _getCustomAttributeValue(product, 'color'),
      ),
    ];

    return items.where((e) => e.value.trim().isNotEmpty).toList();
  }

  String _getCustomAttributeValue(ProductModel product, String code) {
    try {
      final attribute = product.customAttributes.firstWhere(
        (item) => item.attributeCode == code,
      );

      final value = attribute.value;
      if (value == null) return '';

      if (value is List) {
        return value.join(', ');
      }

      return value.toString().trim();
    } catch (_) {
      return '';
    }
  }
}

class _ProductInfoItem {
  final String label;
  final String value;
  final bool highlightValue;

  _ProductInfoItem({
    required this.label,
    required this.value,
    this.highlightValue = false,
  });
}

class _ProductInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlightValue;

  const _ProductInfoRow({
    required this.label,
    required this.value,
    this.highlightValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE3E3E3)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: highlightValue
                        ? const Color(0xFFD7262E)
                        : const Color(0xFF8B8B8B),
                  ),
                ),
              ),
            ),
            Container(width: 1, color: const Color(0xFFE3E3E3)),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                child: Text(
                  '$label:',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                    color: const Color(0xFF3E3E3E),
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
