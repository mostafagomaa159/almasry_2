import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void togglePasswordVisibility() {
    emit(
      state.copyWith(
        isPasswordHidden: !state.isPasswordHidden,
      ),
    );
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        isConfirmPasswordHidden: !state.isConfirmPasswordHidden,
      ),
    );
  }

  void toggleRememberMe() {
    emit(
      state.copyWith(
        rememberMe: !state.rememberMe,
      ),
    );
  }

  void setLoginValidationErrors({
    String? emailOrPhoneError,
    String? passwordError,
  }) {
    emit(
      state.copyWith(
        emailOrPhoneError: emailOrPhoneError,
        passwordError: passwordError,
        nameError: null,
        confirmPasswordError: null,
      ),
    );
  }

  void clearLoginValidationErrors() {
    emit(
      state.copyWith(
        emailOrPhoneError: null,
        passwordError: null,
      ),
    );
  }

  void setRegisterValidationErrors({
    String? firstNameError,
    String? lastNameError,
    String? phoneError,
    String? emailError,
    String? passwordError,
  }) {
    emit(
      state.copyWith(
        firstNameError: firstNameError,
        lastNameError: lastNameError,
        phoneError: phoneError,
        emailError: emailError,
        passwordError: passwordError,
      ),
    );
  }

  void clearRegisterValidationErrors() {
    emit(
      state.copyWith(
        firstNameError: null,
        lastNameError: null,
        phoneError: null,
        emailError: null,
        passwordError: null,
      ),
    );
  }

  void clearValidationErrors() {
    emit(
      state.copyWith(
        nameError: null,
        emailOrPhoneError: null,
        passwordError: null,
        confirmPasswordError: null,
        firstNameError: null,
        lastNameError: null,
        phoneError: null,
        emailError: null,
      ),
    );
  }

  Future<void> login() async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(isLoading: false));
  }

  Future<void> register() async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(isLoading: false));
  }

  Future<void> sendVerificationCode() async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(isLoading: false));
  }
}
