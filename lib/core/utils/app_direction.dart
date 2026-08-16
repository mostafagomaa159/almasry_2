import 'package:flutter/material.dart';

/// The app's navigation icons, in one place so "which way does this point"
/// is never decided at a call site.
///
/// These deliberately do **not** mirror with the locale: the product shows a
/// left-pointing back chevron and a right-pointing forward chevron in both
/// Arabic and English. That is why nothing here takes a [BuildContext] —
/// adding one back would be the first step toward re-introducing mirroring.
class AppDirection {
  const AppDirection._();

  static IconData back({bool rounded = false}) {
    return rounded
        ? Icons.arrow_back_ios_new_rounded
        : Icons.arrow_back_ios_new;
  }

  static IconData forward({bool rounded = false}) {
    return rounded ? Icons.arrow_forward_ios_rounded : Icons.arrow_forward_ios;
  }

  static IconData get chevronForward => Icons.chevron_right;

  static IconData get chevronBack => Icons.chevron_left;
}
