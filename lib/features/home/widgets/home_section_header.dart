part of '../home_imports.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? actionTitle;
  final VoidCallback? onActionTap;
  final bool showAction;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionTitle,
    this.onActionTap,
    this.showAction = true,
  });

  @override
  Widget build(BuildContext context) {
    final String resolvedActionTitle = actionTitle ?? LocaleKeys.homeMore.tr();

    final Widget titleWidget = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF11385B),
      ),
    );

    final Widget actionWidget = InkWell(
      onTap: onActionTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              resolvedActionTitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFC4C4C4),
              ),
            ),
            Icon(
              AppDirection.chevronForward,
              size: 16.sp,
              color: const Color(0xFFC4C4C4),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: titleWidget),
          if (showAction) actionWidget,
        ],
      ),
    );
  }
}
