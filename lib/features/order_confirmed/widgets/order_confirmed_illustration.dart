part of '../order_confirmed_imports.dart';

/// The parcel-with-a-tick mark at the top of the screen.
///
/// Drawn rather than loaded: the design's illustration is not among the
/// project's assets, so this composes the same shape — a green parcel with a
/// check badge overlapping its lower trailing corner — out of shapes and
/// icons.
class OrderConfirmedIllustration extends StatelessWidget {
  const OrderConfirmedIllustration({super.key});

  static const Color _parcelStart = Color(0xFF6DDC9A);
  static const Color _parcelEnd = Color(0xFF35C79A);
  static const Color _badgeBackground = Color(0xFFD8F6E9);
  static const Color _badgeTick = Color(0xFF17BE8B);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240.w,
      height: 170.w,
      child: Stack(
        children: <Widget>[
          Container(
            width: 158.w,
            height: 145.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[_parcelStart, _parcelEnd],
              ),
            ),
            child: Stack(
              children: <Widget>[
                // The tape strip down the top of the box.
                PositionedDirectional(
                  start: 52.w,
                  top: 0,
                  child: Container(
                    width: 34.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(6.r),
                      ),
                    ),
                  ),
                ),

                // The two label lines.
                PositionedDirectional(
                  start: 18.w,
                  top: 74.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _labelBar(width: 34.w),
                      8.verticalSpace,
                      _labelBar(width: 34.w),
                    ],
                  ),
                ),
              ],
            ),
          ),

          PositionedDirectional(
            start: 108.w,
            top: 68.w,
            child: Container(
              width: 96.w,
              height: 96.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _badgeBackground,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.check_rounded, size: 52.sp, color: _badgeTick),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelBar({required double width}) {
    return Container(
      width: width,
      height: 11.w,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
}
