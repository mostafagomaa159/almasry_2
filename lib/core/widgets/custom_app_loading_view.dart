import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppLoadingView extends StatelessWidget {
  final double? height;
  final Color color;

  const CustomAppLoadingView({
    super.key,
    this.height,
    this.color = AppColors.primaryRed,
  });

  @override
  Widget build(BuildContext context) {
    final Widget indicator = Center(
      child: CircularProgressIndicator(color: color),
    );

    if (height == null) return indicator;

    return SizedBox(height: height, child: indicator);
  }
}
