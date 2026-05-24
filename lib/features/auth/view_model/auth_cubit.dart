part of '../auth_imports.dart';
class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<RegisterCustomerResponse> registerCustomer({
    required RegisterCustomerRequest request,
  }) async {
    final response = await _apiService.post(
      endPoint: ApiConstants.guestRegister,
      data: request.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiConstants.token}',
        },
      ),
    );

    return RegisterCustomerResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<ActivateAccountResponse> activateAccount({
    required ActivateAccountRequest request,
  }) async {
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
  }

  Future<AuthAfterOtpResponse> loginAfterOtp({
    required AuthAfterOtpRequest request,
  }) async {
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
  }
}
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

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

  Future<void> login() async {
    emit(state.copyWith(isLoading: true, clearAuthErrorMessage: true));

    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(isLoading: false));
  }

  Future<void> register() async {
    emit(state.copyWith(isLoading: true, clearAuthErrorMessage: true));

    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(isLoading: false));
  }

  Future<void> sendVerificationCode() async {
    emit(
      state.copyWith(
        isPhoneAuthLoading: true,
        isPhoneAuthSuccess: false,
        clearOtpError: true,
        clearAuthErrorMessage: true,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    emit(
      state.copyWith(
        isPhoneAuthLoading: false,
        isPhoneAuthSuccess: true,
      ),
    );
  }

  Future<void> verifyOtpCode(String otp) async {
    if (otp.trim().length != 5) {
      emit(state.copyWith(otpError: 'كود التحقق يجب أن يكون 5 أرقام'));
      return;
    }

    emit(
      state.copyWith(
        isOtpVerificationLoading: true,
        clearOtpError: true,
        clearAuthErrorMessage: true,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    emit(
      state.copyWith(
        isOtpVerificationLoading: false,
        isOtpVerified: true,
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
}
