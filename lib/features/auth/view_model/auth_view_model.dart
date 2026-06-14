part of '../auth_imports.dart';

class AuthViewModel {
  final ApiService _apiService = sl<ApiService>();

  final GenericCubit<AuthData> authCubit =
  GenericCubit<AuthData>(const AuthData());

  void togglePasswordVisibility() {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
        isPasswordHidden: !authCubit.state.data.isPasswordHidden,
      ),
    );
  }

  void toggleConfirmPasswordVisibility() {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
        isConfirmPasswordHidden: !authCubit.state.data.isConfirmPasswordHidden,
      ),
    );
  }

  void toggleRememberMe() {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
        rememberMe: !authCubit.state.data.rememberMe,
      ),
    );
  }

  void setLoginValidationErrors({
    String? emailOrPhoneError,
    String? passwordError,
  }) {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
        emailOrPhoneError: emailOrPhoneError,
        passwordError: passwordError,
        clearNameError: true,
        clearConfirmPasswordError: true,
      ),
    );
  }

  void clearLoginValidationErrors() {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
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
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
        firstNameError: firstNameError,
        lastNameError: lastNameError,
        phoneError: phoneError,
        emailError: emailError,
        passwordError: passwordError,
      ),
    );
  }

  void clearRegisterValidationErrors() {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
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
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
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
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
        verificationPhone: phone,
        isPhoneAuthSuccess: true,
        clearOtpError: true,
        clearAuthErrorMessage: true,
      ),
    );
  }

  void clearOtpState() {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
        isPhoneAuthLoading: false,
        isOtpVerificationLoading: false,
        isPhoneAuthSuccess: false,
        isOtpVerified: false,
        otpCountdownSeconds: 30,
        canResendOtp: false,
        clearOtpError: true,
        clearAuthErrorMessage: true,
        clearVerificationPhone: true,
        clearVerificationCode: true,
      ),
    );
  }

  void updateOtpCountdown(int seconds) {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
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

  Future<Map<String, dynamic>> _forgetPassword({
    required ForgetPasswordRequest request,
  }) async {
    final response = await _apiService.post(
      endPoint: ApiConstants.forgetPassword,
      data: request.toJson(),
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<ActivateAccountResponse> _activateAccount({
    required ActivateAccountRequest request,
  }) async {
    final response = await _apiService.post(
      endPoint: ApiConstants.activateAccount,
      data: request.toJson(),
    );

    return ActivateAccountResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<AuthAfterOtpResponse> _loginAfterOtp({
    required AuthAfterOtpRequest request,
  }) async {
    final response = await _apiService.post(
      endPoint: ApiConstants.authAfterOtp,
      data: request.toJson(),
    );

    return AuthAfterOtpResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> login() async {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
        isLoading: true,
        clearAuthErrorMessage: true,
      ),
    );

    try {
      await Future.delayed(const Duration(seconds: 1));

      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          isLoading: false,
        ),
      );
    } catch (e) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          isLoading: false,
          authErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> register() async {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
        isLoading: true,
        clearAuthErrorMessage: true,
      ),
    );

    try {
      await Future.delayed(const Duration(seconds: 1));

      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          isLoading: false,
        ),
      );
    } catch (e) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          isLoading: false,
          authErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<bool> startPhoneAuth(String phone) async {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
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

      final response = await _forgetPassword(request: request);

      final status = (response['status'] ?? '').toString().toLowerCase();
      final code = (response['code'] ?? '').toString();

      if (status != 'success' || code.isEmpty) {
        authCubit.onUpdateData(
          authCubit.state.data.copyWith(
            isPhoneAuthLoading: false,
            isPhoneAuthSuccess: false,
            authErrorMessage:
            (response['message'] ?? 'فشل إرسال كود التحقق').toString(),
          ),
        );
        return false;
      }

      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          isPhoneAuthLoading: false,
          isPhoneAuthSuccess: true,
          verificationPhone: normalizedPhone,
          verificationCode: code,
          otpCountdownSeconds: 30,
          canResendOtp: false,
          clearOtpError: true,
          clearAuthErrorMessage: true,
        ),
      );

      return true;
    } on DioException catch (e) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          isPhoneAuthLoading: false,
          isPhoneAuthSuccess: false,
          authErrorMessage: _extractApiMessage(e),
        ),
      );
      return false;
    } catch (e) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
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
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          otpError: 'كود التحقق يجب أن يكون 5 أرقام',
        ),
      );
      return false;
    }

    final phone = authCubit.state.data.verificationPhone;
    final savedCode = authCubit.state.data.verificationCode;

    if (phone == null || phone.isEmpty) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          authErrorMessage: 'رقم الهاتف غير متوفر لإتمام التحقق',
        ),
      );
      return false;
    }

    if (savedCode == null || savedCode.isEmpty) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          authErrorMessage: 'كود التحقق غير متوفر، أعد إرسال الكود مرة أخرى',
        ),
      );
      return false;
    }

    if (trimmedOtp != savedCode) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          otpError: 'كود التحقق غير صحيح',
          clearAuthErrorMessage: true,
        ),
      );
      return false;
    }

    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
        isOtpVerificationLoading: true,
        isOtpVerified: false,
        clearOtpError: true,
        clearAuthErrorMessage: true,
      ),
    );

    try {
      final activateRequest = ActivateAccountRequest(
        customerId: savedCode,
      );

      final activateResponse = await _activateAccount(
        request: activateRequest,
      );

      if ((activateResponse.status ?? '').toLowerCase() != 'success') {
        authCubit.onUpdateData(
          authCubit.state.data.copyWith(
            isOtpVerificationLoading: false,
            isOtpVerified: false,
            authErrorMessage: activateResponse.message ?? 'فشل تفعيل الحساب',
          ),
        );
        return false;
      }

      final loginRequest = AuthAfterOtpRequest(mobile: phone);

      final loginResponse = await _loginAfterOtp(
        request: loginRequest,
      );

      if ((loginResponse.token ?? '').isEmpty) {
        authCubit.onUpdateData(
          authCubit.state.data.copyWith(
            isOtpVerificationLoading: false,
            isOtpVerified: false,
            authErrorMessage: 'فشل تسجيل الدخول بعد التحقق',
          ),
        );
        return false;
      }

      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          isOtpVerificationLoading: false,
          isOtpVerified: true,
          clearOtpError: true,
          clearAuthErrorMessage: true,
        ),
      );

      return true;
    } on DioException catch (e) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          isOtpVerificationLoading: false,
          isOtpVerified: false,
          authErrorMessage: _extractApiMessage(e),
        ),
      );
      return false;
    } catch (e) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          isOtpVerificationLoading: false,
          isOtpVerified: false,
          authErrorMessage: e.toString(),
        ),
      );
      return false;
    }
  }

  Future<bool> resendVerificationCode() async {
    final phone = authCubit.state.data.verificationPhone;

    if (phone == null || phone.isEmpty) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          authErrorMessage: 'رقم الهاتف غير متوفر لإعادة الإرسال',
        ),
      );
      return false;
    }

    return startPhoneAuth(phone);
  }

}
