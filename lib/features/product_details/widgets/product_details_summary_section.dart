part of '../product_details_imports.dart';

class ProductDetailsSummarySection extends StatelessWidget {
  final String sku;
  final String brand;
  final String title;
  final String price;
  final String oldPrice;
  final bool isInStock;

  const ProductDetailsSummarySection({
    super.key,
    required this.sku,
    required this.brand,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.isInStock,
  });

  @override
  Widget build(BuildContext context) {
    final hasOldPrice = oldPrice.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  sku.trim().isNotEmpty ? '#$sku' : '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFB0B0B0),
                  ),
                ),
              ),
              if (brand.trim().isNotEmpty)
                Text(
                  brand,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFD7262E),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF11385B),
              height: 1.45,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: isInStock
                      ? const Color(0xFF43A047)
                      : const Color(0xFF9E9E9E),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  isInStock
                      ? LocaleKeys.productDetailsInStock.tr()
                      : LocaleKeys.productDetailsOutOfStock.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF11385B),
                ),
              ),
              if (hasOldPrice) ...[
                SizedBox(width: 12.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: Text(
                    oldPrice,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9E9E9E),
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
