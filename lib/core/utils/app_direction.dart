import 'package:flutter/material.dart';

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
