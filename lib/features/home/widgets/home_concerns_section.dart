import 'package:almasry_2/features/home/model/home_concern_model.dart';
import 'package:almasry_2/features/home/widgets/home_wide_info_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeConcernsSection extends StatelessWidget {
  final bool isArabic;
  final List<HomeConcernModel> items;

  const HomeConcernsSection({
    super.key,
    required this.isArabic,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 102.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: isArabic,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return WideInfoCard(
            title: item.titleKey.tr(),
            imagePath: item.imagePath,
          );
        },
      ),
    );
  }
}
