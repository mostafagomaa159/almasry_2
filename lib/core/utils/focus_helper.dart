part of '../core_imports.dart';

class FocusHelper {
  static void unfocusKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
