part of '../product_details_imports.dart';

class ProductDetailsRatingSection extends StatelessWidget {
  final double rating;

  const ProductDetailsRatingSection({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final double safeRating = rating.clamp(0, 5).toDouble();
    final int filledStars = safeRating.round().clamp(0, 5);
    final bool hasRating = safeRating > 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.productDetailsRating.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF11385B),
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFE6E6E6)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 68.w,
                  height: 68.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFE6E6E6)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    safeRating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFD7262E),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 2.w,
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < filledStars
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: const Color(0xFFD7262E),
                            size: 22.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        hasRating
                            ? LocaleKeys.productDetailsRatingHas.tr()
                            : LocaleKeys.productDetailsRatingNone.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6F6F6F),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
