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
    final bool isArabic = context.locale.languageCode == 'ar';
    final String resolvedActionTitle =
        actionTitle ?? (isArabic ? 'المزيد' : 'More');

    Widget titleWidget = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: isArabic ? TextAlign.right : TextAlign.left,
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
            if (isArabic)
              Icon(
                Icons.chevron_left,
                size: 16.sp,
                color: const Color(0xFFC4C4C4),
              ),
            Text(
              resolvedActionTitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFC4C4C4),
              ),
            ),
            if (!isArabic)
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
        children: isArabic
            ? [
          if (showAction) actionWidget,
          Flexible(child: titleWidget),
        ]
            : [
          Flexible(child: titleWidget),
          if (showAction) actionWidget,
        ],
      ),
    );
  }
}
