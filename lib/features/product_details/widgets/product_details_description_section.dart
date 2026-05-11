import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsDescriptionSection extends StatelessWidget {
  final String description;

  const ProductDetailsDescriptionSection({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LocaleKeys.productDetailsDescription.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF11385B),
              ),
            ),
            const Spacer(),
            Text(
              LocaleKeys.productDetailsMore.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9C9C9C),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Text(
          description,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8C8C8C),
            height: 1.55,
          ),
        ),
      ],
    );
  }
}
