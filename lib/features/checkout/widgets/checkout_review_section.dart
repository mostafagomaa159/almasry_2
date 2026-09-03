part of '../checkout_imports.dart';

class CheckoutReviewSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child;

  const CheckoutReviewSection({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 1.h, thickness: 1.h, color: AppColors.iconEdit),

        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textGraphite,
                    ),
                  ),
                ),

                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 28.sp,
                  color: AppColors.iconSectionToggle,
                ),
              ],
            ),
          ),
        ),

        if (isExpanded)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 18.h),
            child: child,
          ),
      ],
    );
  }
}

class CheckoutReviewRow extends StatelessWidget {
  final String label;
  final String value;

  final bool isCompact;

  const CheckoutReviewRow({
    super.key,
    required this.label,
    required this.value,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget labelWidget = Text(
      label,
      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textGraphite,
      ),
    );

    final Widget valueWidget = Text(
      value,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: isCompact ? FontWeight.w700 : FontWeight.w400,
        color: isCompact ? AppColors.textGraphite : AppColors.textReviewValue,
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isCompact
            ? <Widget>[Expanded(child: labelWidget), valueWidget]
            : <Widget>[
                Expanded(flex: 4, child: labelWidget),
                12.horizontalSpace,
                Expanded(flex: 6, child: valueWidget),
              ],
      ),
    );
  }
}
