import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// The centred spinner every screen shows while its first request is in
/// flight. Pass [height] when it stands in for content of a known size, so the
/// page doesn't jump once the data lands.
class AppLoadingView extends StatelessWidget {
  final double? height;
  final Color color;

  const AppLoadingView({
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
