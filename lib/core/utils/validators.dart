import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';



class Validators {
  static String? validateName(String value) {
    if (value.trim().isEmpty) {
      return LocaleKeys.requiredField.tr();
    }

    if (value.trim().length < 2) {
      return LocaleKeys.invalidName.tr();
    }

    return null;
  }

  static String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      return LocaleKeys.requiredField.tr();
    }

    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return LocaleKeys.invalidEmail.tr();
    }

    return null;
  }

  static String? validatePhone(String value) {
    if (value.trim().isEmpty) {
      return LocaleKeys.requiredField.tr();
    }

    final RegExp phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return LocaleKeys.invalidPhone.tr();
    }

    return null;
  }

  static String? validateEmailOrPhone(String value) {
    if (value.trim().isEmpty) {
      return LocaleKeys.requiredField.tr();
    }

    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    final RegExp phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    final String trimmedValue = value.trim();

    if (!emailRegex.hasMatch(trimmedValue) &&
        !phoneRegex.hasMatch(trimmedValue)) {
      return LocaleKeys.invalidEmailOrPhone.tr();
    }

    return null;
  }

  static String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return LocaleKeys.requiredField.tr();
    }

    if (value.length < 8) {
      return LocaleKeys.invalidPassword.tr();
    }

    return null;
  }

  static String? validateStrongPassword(String value) {
    if (value.trim().isEmpty) {
      return LocaleKeys.requiredField.tr();
    }

    if (value.length < 8) {
      return LocaleKeys.invalidStrongPassword.tr();
    }

    final RegExp uppercaseRegex = RegExp(r'[A-Z]');
    final RegExp numberRegex = RegExp(r'[0-9]');

    if (!uppercaseRegex.hasMatch(value) || !numberRegex.hasMatch(value)) {
      return LocaleKeys.invalidStrongPassword.tr();
    }

    return null;
  }

  static String? validateConfirmPassword({
    required String password,
    required String confirmPassword,
  }) {
    if (confirmPassword.trim().isEmpty) {
      return LocaleKeys.requiredField.tr();
    }

    if (password != confirmPassword) {
      return LocaleKeys.passwordNotMatch.tr();
    }

    return null;
  }
}
