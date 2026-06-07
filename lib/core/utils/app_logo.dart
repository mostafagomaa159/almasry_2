
import 'package:almasry_2/core/constants/app_images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppLogo {
  static String asset(BuildContext context) {
    return context.locale.languageCode == 'ar'
        ? AppImages.logoAr
        : AppImages.logoEn;
  }
}
