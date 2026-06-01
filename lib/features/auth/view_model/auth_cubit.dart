part of '../auth_imports.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<Map<String, dynamic>> forgetPassword({
    required ForgetPasswordRequest request,
  }) async {
    try {
      final response = await _apiService.post(
        endPoint: ApiConstants.forgetPassword,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiConstants.token}',
          },
        ),
      );

      return Map<String, dynamic>.from(response.data as Map);
    } on DioException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  Future<ActivateAccountResponse> activateAccount({
    required ActivateAccountRequest request,
  }) async {
    try {
      final response = await _apiService.post(
        endPoint: ApiConstants.activateAccount,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiConstants.token}',
          },
        ),
      );

      return ActivateAccountResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  Future<AuthAfterOtpResponse> loginAfterOtp({
    required AuthAfterOtpRequest request,
  }) async {
    try {
      final response = await _apiService.post(
        endPoint: ApiConstants.authAfterOtp,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiConstants.token}',
          },
        ),
      );

      return AuthAfterOtpResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        isConfirmPasswordHidden: !state.isConfirmPasswordHidden,
      ),
    );
  }

  void toggleRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  void setLoginValidationErrors({
    String? emailOrPhoneError,
    String? passwordError,
  }) {
    emit(
      state.copyWith(
        emailOrPhoneError: emailOrPhoneError,
        passwordError: passwordError,
        clearNameError: true,
        clearConfirmPasswordError: true,
      ),
    );
  }

  void clearLoginValidationErrors() {
    emit(
      state.copyWith(
        clearEmailOrPhoneError: true,
        clearPasswordError: true,
        clearAuthErrorMessage: true,
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
        clearFirstNameError: true,
        clearLastNameError: true,
        clearPhoneError: true,
        clearEmailError: true,
        clearPasswordError: true,
        clearAuthErrorMessage: true,
      ),
    );
  }

  void clearValidationErrors() {
    emit(
      state.copyWith(
        clearNameError: true,
        clearEmailOrPhoneError: true,
        clearPasswordError: true,
        clearConfirmPasswordError: true,
        clearFirstNameError: true,
        clearLastNameError: true,
        clearPhoneError: true,
        clearEmailError: true,
        clearOtpError: true,
        clearAuthErrorMessage: true,
      ),
    );
  }

  void setVerificationPhone(String phone) {
    emit(
      state.copyWith(
        verificationPhone: phone,
        isPhoneAuthSuccess: true,
        clearOtpError: true,
        clearAuthErrorMessage: true,
      ),
    );
  }

  void clearOtpState() {
    emit(
      state.copyWith(
        isPhoneAuthLoading: false,
        isOtpVerificationLoading: false,
        isPhoneAuthSuccess: false,
        isOtpVerified: false,
        otpCountdownSeconds: 30,
        canResendOtp: false,
        clearOtpError: true,
        clearAuthErrorMessage: true,
        clearVerificationPhone: true,
      ),
    );
  }

  void updateOtpCountdown(int seconds) {
    emit(
      state.copyWith(
        otpCountdownSeconds: seconds,
        canResendOtp: seconds == 0,
      ),
    );
  }

  String _normalizePhone(String phone) {
    final cleaned = phone.trim().replaceAll(' ', '');

    if (cleaned.startsWith('+2')) return cleaned;
    if (cleaned.startsWith('2')) return '+$cleaned';
    if (cleaned.startsWith('0')) return '+2$cleaned';

    return cleaned;
  }

  String _extractApiMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    if (data is Map) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return e.message ?? 'حدث خطأ غير متوقع';
  }

  Future<void> login() async {
    emit(state.copyWith(isLoading: true, clearAuthErrorMessage: true));

    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          authErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> register() async {
    emit(state.copyWith(isLoading: true, clearAuthErrorMessage: true));

    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          authErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<bool> startPhoneAuth(String phone) async {
    emit(
      state.copyWith(
        isPhoneAuthLoading: true,
        isPhoneAuthSuccess: false,
        isOtpVerified: false,
        clearOtpError: true,
        clearAuthErrorMessage: true,
      ),
    );

    try {
      final normalizedPhone = _normalizePhone(phone);
      final request = ForgetPasswordRequest(identity: normalizedPhone);

      await _repository.forgetPassword(request: request);

      emit(
        state.copyWith(
          isPhoneAuthLoading: false,
          isPhoneAuthSuccess: true,
          verificationPhone: normalizedPhone,
          otpCountdownSeconds: 30,
          canResendOtp: false,
          clearOtpError: true,
          clearAuthErrorMessage: true,
        ),
      );

      return true;
    } on DioException catch (e) {
      emit(
        state.copyWith(
          isPhoneAuthLoading: false,
          isPhoneAuthSuccess: false,
          authErrorMessage: _extractApiMessage(e),
        ),
      );
      return false;
    } catch (e) {
      emit(
        state.copyWith(
          isPhoneAuthLoading: false,
          isPhoneAuthSuccess: false,
          authErrorMessage: e.toString(),
        ),
      );
      return false;
    }
  }

  Future<bool> sendVerificationCode(String phone) {
    return startPhoneAuth(phone);
  }

  Future<bool> verifyOtpCode(String otp) async {
    final trimmedOtp = otp.trim();

    if (trimmedOtp.length != 5) {
      emit(state.copyWith(otpError: 'كود التحقق يجب أن يكون 5 أرقام'));
      return false;
    }

    final phone = state.verificationPhone;

    if (phone == null || phone.isEmpty) {
      emit(
        state.copyWith(
          authErrorMessage: 'رقم الهاتف غير متوفر لإتمام التحقق',
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        isOtpVerificationLoading: true,
        isOtpVerified: false,
        clearOtpError: true,
        clearAuthErrorMessage: true,
      ),
    );

    try {
      final activateRequest = ActivateAccountRequest(
        customerId: trimmedOtp,
      );

      await _repository.activateAccount(request: activateRequest);

      final loginRequest = AuthAfterOtpRequest(mobile: phone);
      await _repository.loginAfterOtp(request: loginRequest);

      emit(
        state.copyWith(
          isOtpVerificationLoading: false,
          isOtpVerified: true,
          clearOtpError: true,
          clearAuthErrorMessage: true,
        ),
      );

      return true;
    } on DioException catch (e) {
      emit(
        state.copyWith(
          isOtpVerificationLoading: false,
          isOtpVerified: false,
          authErrorMessage: _extractApiMessage(e),
        ),
      );
      return false;
    } catch (e) {
      emit(
        state.copyWith(
          isOtpVerificationLoading: false,
          isOtpVerified: false,
          authErrorMessage: e.toString(),
        ),
      );
      return false;
    }
  }

  Future<bool> resendVerificationCode() async {
    final phone = state.verificationPhone;

    if (phone == null || phone.isEmpty) {
      emit(
        state.copyWith(
          authErrorMessage: 'رقم الهاتف غير متوفر لإعادة الإرسال',
        ),
      );
      return false;
    }

    return startPhoneAuth(phone);
  }
}
