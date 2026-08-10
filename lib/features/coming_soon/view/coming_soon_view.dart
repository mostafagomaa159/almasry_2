import 'package:easy_localization/easy_localization.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComingSoonView extends StatelessWidget {
  final String title;

  const ComingSoonView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.construction_rounded,
                size: 56,
                color: Colors.grey,
              ),
              16.verticalSpace,
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              8.verticalSpace,
              Text(
                LocaleKeys.comingSoon.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
