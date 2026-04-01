class Validators {
  static String? validateRequired(String value) {
    if (value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? validateName(String value) {
    if (value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    if (value.trim().length < 3) {
      return 'يجب أن يكون الاسم 3 أحرف على الأقل';
    }

    return null;
  }

  static String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }

    return null;
  }

  static String? validatePhone(String value) {
    if (value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    final RegExp phoneRegex = RegExp(r'^01[0125][0-9]{8}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'يرجى إدخال رقم هاتف صحيح';
    }

    return null;
  }

  static String? validateEmailOrPhone(String value) {
    if (value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    final RegExp phoneRegex = RegExp(r'^01[0125][0-9]{8}$');

    final String trimmedValue = value.trim();

    if (!emailRegex.hasMatch(trimmedValue) &&
        !phoneRegex.hasMatch(trimmedValue)) {
      return 'يرجى إدخال بريد إلكتروني أو رقم هاتف صحيح';
    }

    return null;
  }

  static String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    if (value.length < 8) {
      return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
    }

    return null;
  }

  static String? validateConfirmPassword({
    required String password,
    required String confirmPassword,
  }) {
    if (confirmPassword.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    if (password != confirmPassword) {
      return 'كلمتا المرور غير متطابقتين';
    }

    return null;
  }
}
