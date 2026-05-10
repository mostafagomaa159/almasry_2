import 'package:almasry_2/features/home/model/home_service_model.dart';
import 'package:almasry_2/features/home/widgets/home_service_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeServicesSection extends StatelessWidget {
  final List<HomeServiceModel> items;

  const HomeServicesSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GridView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.82,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return ServiceCard(
            iconPath: item.iconPath,
            title: item.titleKey.tr(),
            description: item.descriptionKey.tr(),
          );
        },
      ),
    );
  }
}
