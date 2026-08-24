part of '../checkout_review_imports.dart';

/// The collapsible shell the three review sections share: a title row with a
/// chevron, and a horizontal rule above and below.
///
/// A presentational leaf, so it takes its title and child rather than the
/// ViewModel.
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

  static const Color _ruleColor = Color(0xFF8A8A8A);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 1.h, thickness: 1.h, color: _ruleColor),

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
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                ),

                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 28.sp,
                  color: const Color(0xFF8B4A4A),
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

/// A label / value line, used by both the order and bill sections.
class CheckoutReviewRow extends StatelessWidget {
  final String label;
  final String value;

  /// The bill rows put the amount hard against the trailing edge; the order
  /// rows give the value its own column so long addresses wrap.
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
        color: const Color(0xFF2C2C2C),
      ),
    );

    final Widget valueWidget = Text(
      value,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: isCompact ? FontWeight.w700 : FontWeight.w400,
        color: isCompact ? const Color(0xFF2C2C2C) : const Color(0xFF6B6B6B),
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
