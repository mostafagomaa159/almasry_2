import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:almasry_2/core/utils/app_direction.dart';
import 'package:flutter/material.dart';

/// The plain white app bar — flat, centred title — that the screens outside the
/// red [CustomAppBar] treatment use.
///
/// Leave [onBack] null to keep Flutter's automatic leading (the shell decides
/// whether a back arrow belongs there); pass it to take the button over, which
/// is what any screen navigating through `NavigationService` wants.
class CustomAppTitleAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final TextStyle? titleStyle;
  final VoidCallback? onBack;
  final IconData? backIcon;
  final Color backIconColor;
  final Color backgroundColor;
  final bool centerTitle;
  final double elevation;
  final List<Widget>? actions;

  const CustomAppTitleAppBar({
    super.key,
    required this.title,
    this.titleStyle,
    this.onBack,
    this.backIcon,
    this.backIconColor = Colors.black,
    this.backgroundColor = AppColors.white,
    this.centerTitle = true,
    this.elevation = 0,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      actions: actions,
      leading: onBack == null
          ? null
          : IconButton(
              onPressed: onBack,
              icon: Icon(
                backIcon ?? AppDirection.back(rounded: true),
                color: backIconColor,
              ),
            ),
      title: Text(title, style: titleStyle),
    );
  }
}
