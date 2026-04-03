class AuthState {
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final bool rememberMe;
  final bool isLoading;

  final String? nameError;
  final String? emailOrPhoneError;
  final String? passwordError;
  final String? confirmPasswordError;

  final String? firstNameError;
  final String? lastNameError;
  final String? phoneError;
  final String? emailError;

  const AuthState({
    this.isPasswordHidden = true,
    this.isConfirmPasswordHidden = true,
    this.rememberMe = false,
    this.isLoading = false,
    this.nameError,
    this.emailOrPhoneError,
    this.passwordError,
    this.confirmPasswordError,
    this.firstNameError,
    this.lastNameError,
    this.phoneError,
    this.emailError,
  });

  AuthState copyWith({
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden,
    bool? rememberMe,
    bool? isLoading,
    String? nameError,
    String? emailOrPhoneError,
    String? passwordError,
    String? confirmPasswordError,
    String? firstNameError,
    String? lastNameError,
    String? phoneError,
    String? emailError,
  }) {
    return AuthState(
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isConfirmPasswordHidden:
      isConfirmPasswordHidden ?? this.isConfirmPasswordHidden,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      nameError: nameError,
      emailOrPhoneError: emailOrPhoneError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      firstNameError: firstNameError,
      lastNameError: lastNameError,
      phoneError: phoneError,
      emailError: emailError,
    );
  }
}
