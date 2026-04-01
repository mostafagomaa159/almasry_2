class AuthState {
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final bool rememberMe;
  final bool isLoading;

  final String? nameError;
  final String? emailOrPhoneError;
  final String? passwordError;
  final String? confirmPasswordError;

  const AuthState({
    this.isPasswordHidden = true,
    this.isConfirmPasswordHidden = true,
    this.rememberMe = false,
    this.isLoading = false,
    this.nameError,
    this.emailOrPhoneError,
    this.passwordError,
    this.confirmPasswordError,
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
    );
  }
}
