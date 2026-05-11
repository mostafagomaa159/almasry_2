import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsRatingSection extends StatelessWidget {
  final double rating;

  const ProductDetailsRatingSection({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final int filledStars = rating.round().clamp(0, 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.productDetailsRating.tr(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 10.w),
            ...List.generate(
              5,
                  (index) => Padding(
                padding: EdgeInsetsDirectional.only(end: 2.w),
                child: Icon(
                  index < filledStars ? Icons.star : Icons.star_border,
                  color: AppColors.primaryRed,
                  size: 22.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
