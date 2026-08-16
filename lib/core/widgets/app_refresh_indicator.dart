import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Pull-to-refresh in the app's colours. Thin on purpose — it exists so every
/// screen gets the same spinner without repeating the theming.
class AppRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const AppRefreshIndicator({
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
