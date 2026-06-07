part of '../auth_imports.dart';

class AuthState {
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final bool rememberMe;
  final bool isLoading;

  final bool isPhoneAuthLoading;
  final bool isOtpVerificationLoading;
  final bool isPhoneAuthSuccess;
  final bool isOtpVerified;

  final String? nameError;
  final String? emailOrPhoneError;
  final String? passwordError;
  final String? confirmPasswordError;

  final String? firstNameError;
  final String? lastNameError;
  final String? phoneError;
  final String? emailError;

  final String? otpError;
  final String? authErrorMessage;
  final String? verificationPhone;
  final String? verificationCode;

  final int otpCountdownSeconds;
  final bool canResendOtp;

  const AuthState({
    this.isPasswordHidden = true,
    this.isConfirmPasswordHidden = true,
    this.rememberMe = false,
    this.isLoading = false,
    this.isPhoneAuthLoading = false,
    this.isOtpVerificationLoading = false,
    this.isPhoneAuthSuccess = false,
    this.isOtpVerified = false,
    this.nameError,
    this.emailOrPhoneError,
    this.passwordError,
    this.confirmPasswordError,
    this.firstNameError,
    this.lastNameError,
    this.phoneError,
    this.emailError,
    this.otpError,
    this.authErrorMessage,
    this.verificationPhone,
    this.verificationCode,
    this.otpCountdownSeconds = 30,
    this.canResendOtp = false,
  });

  AuthState copyWith({
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden,
    bool? rememberMe,
    bool? isLoading,
    bool? isPhoneAuthLoading,
    bool? isOtpVerificationLoading,
    bool? isPhoneAuthSuccess,
    bool? isOtpVerified,
    String? nameError,
    String? emailOrPhoneError,
    String? passwordError,
    String? confirmPasswordError,
    String? firstNameError,
    String? lastNameError,
    String? phoneError,
    String? emailError,
    String? otpError,
    String? authErrorMessage,
    String? verificationPhone,
    String? verificationCode,
    int? otpCountdownSeconds,
    bool? canResendOtp,
    bool clearNameError = false,
    bool clearEmailOrPhoneError = false,
    bool clearPasswordError = false,
    bool clearConfirmPasswordError = false,
    bool clearFirstNameError = false,
    bool clearLastNameError = false,
    bool clearPhoneError = false,
    bool clearEmailError = false,
    bool clearOtpError = false,
    bool clearAuthErrorMessage = false,
    bool clearVerificationPhone = false,
    bool clearVerificationCode = false,
  }) {
    return AuthState(
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isConfirmPasswordHidden:
      isConfirmPasswordHidden ?? this.isConfirmPasswordHidden,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      isPhoneAuthLoading: isPhoneAuthLoading ?? this.isPhoneAuthLoading,
      isOtpVerificationLoading:
      isOtpVerificationLoading ?? this.isOtpVerificationLoading,
      isPhoneAuthSuccess: isPhoneAuthSuccess ?? this.isPhoneAuthSuccess,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      emailOrPhoneError: clearEmailOrPhoneError
          ? null
          : (emailOrPhoneError ?? this.emailOrPhoneError),
      passwordError: clearPasswordError
          ? null
          : (passwordError ?? this.passwordError),
      confirmPasswordError: clearConfirmPasswordError
          ? null
          : (confirmPasswordError ?? this.confirmPasswordError),
      firstNameError: clearFirstNameError
          ? null
          : (firstNameError ?? this.firstNameError),
      lastNameError: clearLastNameError
          ? null
          : (lastNameError ?? this.lastNameError),
      phoneError: clearPhoneError ? null : (phoneError ?? this.phoneError),
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      otpError: clearOtpError ? null : (otpError ?? this.otpError),
      authErrorMessage: clearAuthErrorMessage
          ? null
          : (authErrorMessage ?? this.authErrorMessage),
      verificationPhone: clearVerificationPhone
          ? null
          : (verificationPhone ?? this.verificationPhone),
      verificationCode: clearVerificationCode
          ? null
          : (verificationCode ?? this.verificationCode),
      otpCountdownSeconds: otpCountdownSeconds ?? this.otpCountdownSeconds,
      canResendOtp: canResendOtp ?? this.canResendOtp,
    );
  }
}
