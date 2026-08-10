import 'package:flutter/material.dart';

/// Direction-aware icons. Material icons do not mirror themselves, so a
/// hardcoded `Icons.arrow_back_ios_new` keeps pointing left in Arabic — where
/// "back" is to the right. Everything that points somewhere should come from
/// here.
class AppDirection {
  const AppDirection._();

  static bool isRtl(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  /// Points the way the user came from.
  static IconData back(BuildContext context, {bool rounded = false}) {
    if (isRtl(context)) {
      return rounded
          ? Icons.arrow_forward_ios_rounded
          : Icons.arrow_forward_ios;
    }

    return rounded
        ? Icons.arrow_back_ios_new_rounded
        : Icons.arrow_back_ios_new;
  }

  /// Points onward — trailing chevrons on rows that open another screen.
  static IconData forward(BuildContext context, {bool rounded = false}) {
    if (isRtl(context)) {
      return rounded
          ? Icons.arrow_back_ios_new_rounded
          : Icons.arrow_back_ios_new;
    }

    return rounded ? Icons.arrow_forward_ios_rounded : Icons.arrow_forward_ios;
  }

  /// The wide chevron used by "see more" affordances.
  static IconData chevronForward(BuildContext context) {
    return isRtl(context) ? Icons.chevron_left : Icons.chevron_right;
  }

  static IconData chevronBack(BuildContext context) {
    return isRtl(context) ? Icons.chevron_right : Icons.chevron_left;
  }
}
