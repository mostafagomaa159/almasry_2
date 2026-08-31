import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CustomAppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primaryRed,
      backgroundColor: AppColors.white,
      child: child,
    );
  }
}
