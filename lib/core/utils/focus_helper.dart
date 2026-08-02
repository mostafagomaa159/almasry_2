import 'package:flutter/material.dart';

class FocusHelper {
  static void unfocusKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
