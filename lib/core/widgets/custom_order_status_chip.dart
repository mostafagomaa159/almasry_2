import 'package:almasry_2/core/widgets/custom_app_badge.dart';
import 'package:flutter/material.dart';
import 'package:almasry_2/core/constants/app_colors.dart';

/// The order state rendered as a pill. Only the colour mapping lives here —
/// the pill itself is an [CustomAppBadge].
class CustomOrderStatusChip extends StatelessWidget {
  final String status;

  const CustomOrderStatusChip({super.key, required this.status});

  Color _backgroundColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.statusPendingBg;
      case 'processing':
        return AppColors.statusProcessingBg;
      case 'complete':
        return AppColors.statusCompleteBg;
      case 'canceled':
      case 'cancelled':
        return AppColors.statusCanceledBg;
      default:
        return AppColors.statusDefaultBg;
    }
  }

  Color _textColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.statusPendingText;
      case 'processing':
        return AppColors.statusProcessingText;
      case 'complete':
        return AppColors.statusCompleteText;
      case 'canceled':
      case 'cancelled':
        return AppColors.statusCanceledText;
      default:
        return AppColors.statusDefaultText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBadge(
      label: status,
      backgroundColor: _backgroundColor(),
      textColor: _textColor(),
    );
  }
}
