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

    // No manual mirroring anywhere in here: `Row` lays its children out along
    // the ambient text direction, `TextAlign.start` follows it, and
    // `Icons.chevron_right` sets `matchTextDirection`, so it flips to point
    // left in Arabic on its own. Branching on the locale would flip a second
    // time and put everything back on the wrong side.
    Widget titleWidget = Text(
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

    Widget actionWidget = InkWell(
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
              Icons.chevron_right,
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
