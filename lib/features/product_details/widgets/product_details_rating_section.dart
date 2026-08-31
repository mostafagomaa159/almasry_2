part of '../product_details_imports.dart';

class ProductDetailsRatingSection extends StatelessWidget {
  final ProductDetailsViewModel vm;
  final ProductDetailModel product;

  const ProductDetailsRatingSection({
    super.key,
    required this.vm,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final List<ProductReviewModel> reviews = product.reviews.items;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.productDetailsComments.tr(
                    args: ['${product.reviewCount}'],
                  ),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navyHeading,
                  ),
                ),
              ),

              _AddReviewButton(vm: vm),
            ],
          ),

          14.verticalSpace,

          _RatingSummaryCard(product: product),

          if (reviews.isNotEmpty) ...[
            14.verticalSpace,
            ...reviews.map(
              (review) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _ReviewCard(review: review),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddReviewButton extends StatelessWidget {
  const _AddReviewButton({required this.vm});

  final ProductDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(10.r);

    return Material(
      color: AppColors.primaryRed,
      borderRadius: radius,
      child: InkWell(
        onTap: vm._addReview,
        borderRadius: radius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: Text(
            LocaleKeys.productDetailsAddReview.tr(),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _RatingSummaryCard extends StatelessWidget {
  const _RatingSummaryCard({required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    final double rating = product.ratingOutOfFive;
    final bool hasRating = rating > 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.borderButton),
      ),
      child: Row(
        children: [
          Container(
            width: 68.w,
            height: 68.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.borderButton),
            ),
            alignment: Alignment.center,
            child: Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.redHeading,
              ),
            ),
          ),

          14.horizontalSpace,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Stars(rating: rating),

                8.verticalSpace,

                Text(
                  hasRating
                      ? LocaleKeys.productDetailsRatingHas.tr()
                      : LocaleKeys.productDetailsRatingNone.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textRatingMuted,
                    height: 1.5,
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

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final ProductReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.borderButton),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.nickname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navyHeading,
                  ),
                ),
              ),

              _Stars(rating: review.ratingOutOfFive, size: 16),
            ],
          ),

          if (review.summary.trim().isNotEmpty) ...[
            6.verticalSpace,
            Text(
              review.summary,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textBody,
              ),
            ),
          ],

          if (review.text.trim().isNotEmpty) ...[
            6.verticalSpace,
            Text(
              review.text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textCaption,
                height: 1.5,
              ),
            ),
          ],

          if (review.createdAt.trim().isNotEmpty) ...[
            8.verticalSpace,
            Text(
              review.createdAt,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textDisabled),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating, this.size = 22});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final int filled = rating.round().clamp(0, 5);

    return Wrap(
      spacing: 2.w,
      children: List.generate(
        5,
        (index) => Icon(
          index < filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: AppColors.redHeading,
          size: size.sp,
        ),
      ),
    );
  }
}
