part of '../auth_imports.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<RegisterCustomerResponse> registerCustomer({
    required RegisterCustomerRequest request,
  }) async {
    try {
      print('========== REGISTER CUSTOMER REQUEST ==========');
      print('registerCustomer endpoint: ${ApiConstants.guestRegister}');
      print('registerCustomer token: ${ApiConstants.token}');
      print('registerCustomer body: ${request.toJson()}');

      final response = await _apiService.post(
        endPoint: ApiConstants.guestRegister,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiConstants.token}',
          },
        ),
      );

      print('registerCustomer statusCode: ${response.statusCode}');
      print('registerCustomer raw response: ${response.data}');
      print('===============================================');

      return RegisterCustomerResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e, s) {
      print('========== REGISTER CUSTOMER DIO ERROR ==========');
      print('message: ${e.message}');
      print('type: ${e.type}');
      print('statusCode: ${e.response?.statusCode}');
      print('responseData: ${e.response?.data}');
      print('responseHeaders: ${e.response?.headers}');
      print('stackTrace: $s');
      print('================================================');
      rethrow;
    } catch (e, s) {
      print('======== REGISTER CUSTOMER UNKNOWN ERROR ========');
      print('error: $e');
      print('stackTrace: $s');
      print('=================================================');
      rethrow;
    }
  }

  Future<ActivateAccountResponse> activateAccount({
    required ActivateAccountRequest request,
  }) async {
    try {
      print('========== ACTIVATE ACCOUNT REQUEST ==========');
      print('activateAccount endpoint: ${ApiConstants.activateAccount}');
      print('activateAccount token: ${ApiConstants.token}');
      print('activateAccount body: ${request.toJson()}');

      final response = await _apiService.post(
        endPoint: ApiConstants.activateAccount,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiConstants.token}',
          },
        ),
      );

      print('activateAccount statusCode: ${response.statusCode}');
      print('activateAccount raw response: ${response.data}');
      print('=============================================');

      return ActivateAccountResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e, s) {
      print('========== ACTIVATE ACCOUNT DIO ERROR ==========');
      print('message: ${e.message}');
      print('type: ${e.type}');
      print('statusCode: ${e.response?.statusCode}');
      print('responseData: ${e.response?.data}');
      print('responseHeaders: ${e.response?.headers}');
      print('stackTrace: $s');
      print('===============================================');
      rethrow;
    } catch (e, s) {
      print('========= ACTIVATE ACCOUNT UNKNOWN ERROR =======');
      print('error: $e');
      print('stackTrace: $s');
      print('===============================================');
      rethrow;
    }
  }

  Future<AuthAfterOtpResponse> loginAfterOtp({
    required AuthAfterOtpRequest request,
  }) async {
    try {
      print('========== LOGIN AFTER OTP REQUEST ==========');
      print('loginAfterOtp endpoint: ${ApiConstants.authAfterOtp}');
      print('loginAfterOtp token: ${ApiConstants.token}');
      print('loginAfterOtp body: ${request.toJson()}');

      final response = await _apiService.post(
        endPoint: ApiConstants.authAfterOtp,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiConstants.token}',
          },
        ),
      );

      print('loginAfterOtp statusCode: ${response.statusCode}');
      print('loginAfterOtp raw response: ${response.data}');
      print('============================================');

      return AuthAfterOtpResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e, s) {
      print('========== LOGIN AFTER OTP DIO ERROR ==========');
      print('message: ${e.message}');
      print('type: ${e.type}');
      print('statusCode: ${e.response?.statusCode}');
      print('responseData: ${e.response?.data}');
      print('responseHeaders: ${e.response?.headers}');
      print('stackTrace: $s');
      print('===============================================');
      rethrow;
    } catch (e, s) {
      print('========= LOGIN AFTER OTP UNKNOWN ERROR =======');
      print('error: $e');
      print('stackTrace: $s');
      print('===============================================');
      rethrow;
    }
  }
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState());

  static const String _generatedPhonePassword = 'Almasry@123456';

  void togglePasswordVisibility() {
    print('togglePasswordVisibility called');
    emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
  }

  void toggleConfirmPasswordVisibility() {
    print('toggleConfirmPasswordVisibility called');
    emit(
      state.copyWith(
        isConfirmPasswordHidden: !state.isConfirmPasswordHidden,
      ),
    );
  }

  void toggleRememberMe() {
    print('toggleRememberMe called');
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  void setLoginValidationErrors({
    String? emailOrPhoneError,
    String? passwordError,
  }) {
    print('setLoginValidationErrors called');
    print('emailOrPhoneError: $emailOrPhoneError');
    print('passwordError: $passwordError');

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
    print('clearLoginValidationErrors called');
    emit(
      state.copyWith(
        clearEmailOrPhoneError: true,
        clearPasswordError: true,
        clearAuthErrorMessage: true,
      ),
    );
  }
  String _normalizePhone(String phone) {
    final cleaned = phone.trim().replaceAll(' ', '');

    if (cleaned.startsWith('+2')) {
      return cleaned;
    }

    if (cleaned.startsWith('2')) {
      return '+$cleaned';
    }

    if (cleaned.startsWith('0')) {
      return '+2$cleaned';
    }

    return cleaned;
  }

  void setRegisterValidationErrors({
    String? firstNameError,
    String? lastNameError,
    String? phoneError,
    String? emailError,
    String? passwordError,
  }) {
    print('setRegisterValidationErrors called');
    print('firstNameError: $firstNameError');
    print('lastNameError: $lastNameError');
    print('phoneError: $phoneError');
    print('emailError: $emailError');
    print('passwordError: $passwordError');

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
    print('clearRegisterValidationErrors called');
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
    print('clearValidationErrors called');
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
    print('setVerificationPhone called with phone: $phone');
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
    print('clearOtpState called');
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
    print('updateOtpCountdown called with seconds: $seconds');
    emit(
      state.copyWith(
        otpCountdownSeconds: seconds,
        canResendOtp: seconds == 0,
      ),
    );
  }

  Future<void> login() async {
    print('========== LOGIN START ==========');
    emit(state.copyWith(isLoading: true, clearAuthErrorMessage: true));

    try {
      print('login() simulating request...');
      await Future.delayed(const Duration(seconds: 1));
      print('login() success');

      emit(state.copyWith(isLoading: false));
      print('========== LOGIN END SUCCESS ==========');
    } catch (e, s) {
      print('login() error: $e');
      print('login() stackTrace: $s');

      emit(
        state.copyWith(
          isLoading: false,
          authErrorMessage: e.toString(),
        ),
      );
      print('========== LOGIN END FAILURE ==========');
    }
  }

  Future<void> register() async {
    print('========== REGISTER START ==========');
    emit(state.copyWith(isLoading: true, clearAuthErrorMessage: true));

    try {
      print('register() simulating request...');
      await Future.delayed(const Duration(seconds: 1));
      print('register() success');

      emit(state.copyWith(isLoading: false));
      print('========== REGISTER END SUCCESS ==========');
    } catch (e, s) {
      print('register() error: $e');
      print('register() stackTrace: $s');

      emit(
        state.copyWith(
          isLoading: false,
          authErrorMessage: e.toString(),
        ),
      );
      print('========== REGISTER END FAILURE ==========');
    }
  }

  Future<bool> startPhoneAuth(String phone) async {
    print('========== START PHONE AUTH ==========');
    print('phone: $phone');

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

      print('original phone: $phone');
      print('normalized phone: $normalizedPhone');

      final request = RegisterCustomerRequest(
        mobile: normalizedPhone,
        password: _generatedPhonePassword,
      );

      print('generated request for startPhoneAuth: ${request.toJson()}');
      print('calling repository.registerCustomer...');

      final response = await _repository.registerCustomer(request: request);

      print('registerCustomer success');
      print('response.mobileNumber: ${response.mobileNumber}');

      emit(
        state.copyWith(
          isPhoneAuthLoading: false,
          isPhoneAuthSuccess: true,
          verificationPhone: response.mobileNumber ?? normalizedPhone,
          otpCountdownSeconds: 30,
          canResendOtp: false,
          clearOtpError: true,
          clearAuthErrorMessage: true,
        ),
      );

      print('startPhoneAuth emit success');
      print('verificationPhone saved: ${response.mobileNumber ?? normalizedPhone}');
      print('========== START PHONE AUTH SUCCESS ==========');

      return true;
    } on DioException catch (e, s) {
      print('========== START PHONE AUTH DIO ERROR ==========');
      print('message: ${e.message}');
      print('type: ${e.type}');
      print('statusCode: ${e.response?.statusCode}');
      print('responseData: ${e.response?.data}');
      print('responseHeaders: ${e.response?.headers}');
      print('stackTrace: $s');
      print('================================================');

      emit(
        state.copyWith(
          isPhoneAuthLoading: false,
          isPhoneAuthSuccess: false,
          authErrorMessage: e.response?.data.toString() ?? e.message,
        ),
      );

      print('startPhoneAuth emit failure with DioException');
      return false;
    } catch (e, s) {
      print('========== START PHONE AUTH UNKNOWN ERROR ==========');
      print('error: $e');
      print('stackTrace: $s');
      print('====================================================');

      emit(
        state.copyWith(
          isPhoneAuthLoading: false,
          isPhoneAuthSuccess: false,
          authErrorMessage: e.toString(),
        ),
      );

      print('startPhoneAuth emit failure with unknown error');
      return false;
    }
  }


  Future<bool> sendVerificationCode(String phone) async {
    print('========== SEND VERIFICATION CODE ==========');
    print('sendVerificationCode called with phone: $phone');

    final result = await startPhoneAuth(phone);

    print('sendVerificationCode result: $result');
    print('===========================================');

    return result;
  }

  Future<bool> verifyOtpCode(String otp) async {
    print('========== VERIFY OTP START ==========');
    print('raw otp: $otp');

    final trimmedOtp = otp.trim();
    print('trimmed otp: $trimmedOtp');

    if (trimmedOtp.length != 5) {
      print('OTP validation failed: length is not 5');

      emit(state.copyWith(otpError: 'كود التحقق يجب أن يكون 5 أرقام'));
      return false;
    }

    final String? phone = state.verificationPhone;
    print('verificationPhone from state: $phone');

    if (phone == null || phone.isEmpty) {
      print('verificationPhone missing from state');

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

      print('activateAccount request body: ${activateRequest.toJson()}');
      print('calling repository.activateAccount...');

      final activateResponse = await _repository.activateAccount(
        request: activateRequest,
      );

      print('activateAccount success: $activateResponse');

      final loginRequest = AuthAfterOtpRequest(
        mobile: phone,
      );

      print('loginAfterOtp request body: ${loginRequest.toJson()}');
      print('calling repository.loginAfterOtp...');

      final loginResponse = await _repository.loginAfterOtp(
        request: loginRequest,
      );

      print('loginAfterOtp success: $loginResponse');

      emit(
        state.copyWith(
          isOtpVerificationLoading: false,
          isOtpVerified: true,
          clearOtpError: true,
          clearAuthErrorMessage: true,
        ),
      );

      print('verifyOtpCode emit success');
      print('========== VERIFY OTP SUCCESS ==========');

      return true;
    } on DioException catch (e, s) {
      print('========== VERIFY OTP DIO ERROR ==========');
      print('message: ${e.message}');
      print('type: ${e.type}');
      print('statusCode: ${e.response?.statusCode}');
      print('responseData: ${e.response?.data}');
      print('responseHeaders: ${e.response?.headers}');
      print('stackTrace: $s');
      print('=========================================');

      emit(
        state.copyWith(
          isOtpVerificationLoading: false,
          isOtpVerified: false,
          authErrorMessage: e.response?.data.toString() ?? e.message,
        ),
      );

      print('verifyOtpCode emit failure with DioException');
      return false;
    } catch (e, s) {
      print('========== VERIFY OTP UNKNOWN ERROR ==========');
      print('error: $e');
      print('stackTrace: $s');
      print('=============================================');

      emit(
        state.copyWith(
          isOtpVerificationLoading: false,
          isOtpVerified: false,
          authErrorMessage: e.toString(),
        ),
      );

      print('verifyOtpCode emit failure with unknown error');
      return false;
    }
  }

  Future<bool> resendVerificationCode() async {
    print('========== RESEND VERIFICATION CODE ==========');

    final String? phone = state.verificationPhone;
    print('verificationPhone from state: $phone');

    if (phone == null || phone.isEmpty) {
      print('Cannot resend OTP: verificationPhone is missing');

      emit(
        state.copyWith(
          authErrorMessage: 'رقم الهاتف غير متوفر لإعادة الإرسال',
        ),
      );
      return false;
    }

    final result = await startPhoneAuth(phone);

    print('resendVerificationCode result: $result');
    print('=============================================');

    return result;
  }
}
