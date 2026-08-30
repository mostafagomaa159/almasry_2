import 'package:easy_localization/easy_localization.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_api.dart';
import 'package:almasry_2/core/models/request/login/activate_account_model.dart';
import 'package:almasry_2/core/models/request/login/auth_after_otp_model.dart';
import 'package:almasry_2/core/models/request/login/forget_password_model.dart';
import 'package:almasry_2/core/models/response/login/activate_account_model.dart';
import 'package:almasry_2/core/models/response/login/register_customer_otp_model.dart';
import 'package:almasry_2/core/models/response/login/user_model.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/core/services/app_startup_service.dart';
import 'package:almasry_2/core/services/cart_service.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:dio/dio.dart';
import 'package:almasry_2/core/utils/error_message.dart';
import 'package:almasry_2/core/constants/app_durations.dart';

class AuthSessionService {
  /// Services

  final ApiService _apiService = sl<ApiService>();
  final SharedPrefsServices _prefs = sl<SharedPrefsServices>();
  final AppStartupService _startup = sl<AppStartupService>();

  /// Variables

  final GenericCubit<UserModel> authCubit = GenericCubit<UserModel>(
    const UserModel(),
  );

  /// State

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

  /// Helpers

  String _normalizePhone(String phone) {
    final cleaned = phone.trim().replaceAll(' ', '');

    if (cleaned.startsWith('+2')) return cleaned;
    if (cleaned.startsWith('2')) return '+$cleaned';
    if (cleaned.startsWith('0')) return '+2$cleaned';

    return cleaned;
  }

  /// Api

  Future<Map<String, dynamic>> _forgetPassword({
    required ForgetPasswordModel request,
  }) async {
    final response = await _apiService.post(
      endPoint: ApiConstants.forgetPassword,
      data: request.toJson(),
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<ActivateAccountModel> _activateAccount({
    required ActivateAccountRequest request,
  }) async {
    final response = await _apiService.post(
      endPoint: ApiConstants.activateAccount,
      data: request.toJson(),
    );

    return ActivateAccountModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<RegisterCustomerOtpModel> _loginAfterOtp({
    required AuthAfterOtpModel request,
  }) async {
    final response = await _apiService.post(
      endPoint: ApiConstants.authAfterOtp,
      data: request.toJson(),
    );

    return RegisterCustomerOtpModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// Flows

  Future<void> login() async {
    authCubit.onUpdateData(
      authCubit.state.data.copyWith(
        isLoading: true,
        clearAuthErrorMessage: true,
      ),
    );

    try {
      await Future.delayed(AppDurations.authStub);

      authCubit.onUpdateData(authCubit.state.data.copyWith(isLoading: false));
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
      await Future.delayed(AppDurations.authStub);

      authCubit.onUpdateData(authCubit.state.data.copyWith(isLoading: false));
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
      final request = ForgetPasswordModel(identity: normalizedPhone);

      final response = await _forgetPassword(request: request);

      final status = (response['status'] ?? '').toString().toLowerCase();
      final code = (response['code'] ?? '').toString();

      if (status != 'success' || code.isEmpty) {
        authCubit.onUpdateData(
          authCubit.state.data.copyWith(
            isPhoneAuthLoading: false,
            isPhoneAuthSuccess: false,
            authErrorMessage:
                (response['message'] ?? LocaleKeys.otpSendFailed.tr())
                    .toString(),
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
          authErrorMessage: errorMessageFrom(e),
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

  /// A verified OTP is a login, so it has to leave the same trace the email
  /// path does — before this, the phone flow marked nothing and the app still
  /// considered the user a guest on the next screen.
  ///
  /// The email is written when the reply carries one: the checkout sends it to
  /// Magento with the cart, and a phone-registered customer never types it.
  Future<void> _saveOtpSession({
    required String phone,
    required RegisterCustomerOtpModel response,
  }) async {
    await _prefs.setString(PrefKeys.phone, phone);

    final String email = (response.email ?? '').trim();

    if (email.isNotEmpty) await _prefs.setString(PrefKeys.email, email);

    // The token is the point of this reply: from here every GraphQL call runs
    // as the customer, which is what makes the cart theirs and lets
    // `placeOrder` file the order under the account.
    final String token = (response.token ?? '').trim();

    if (token.isNotEmpty) {
      await _prefs.setString(PrefKeys.customerToken, token);

      // The reply also carries `cart_id`, which this ignores on purpose: it is
      // undocumented whether that id is the masked one GraphQL wants, and
      // `customerCart` answers the same question authoritatively.
      await sl<CartService>().adoptCustomerCart();
    }

    await _startup.saveLoggedIn();
  }

  Future<bool> verifyOtpCode(String otp) async {
    final trimmedOtp = otp.trim();

    if (trimmedOtp.length != 5) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          otpError: LocaleKeys.otpInvalidLength.tr(),
        ),
      );
      return false;
    }

    final phone = authCubit.state.data.verificationPhone;
    final savedCode = authCubit.state.data.verificationCode;

    if (phone == null || phone.isEmpty) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          authErrorMessage: LocaleKeys.otpPhoneMissing.tr(),
        ),
      );
      return false;
    }

    if (savedCode == null || savedCode.isEmpty) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          authErrorMessage: LocaleKeys.otpCodeMissing.tr(),
        ),
      );
      return false;
    }

    if (trimmedOtp != savedCode) {
      authCubit.onUpdateData(
        authCubit.state.data.copyWith(
          otpError: LocaleKeys.otpIncorrect.tr(),
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
      final activateRequest = ActivateAccountRequest(customerId: savedCode);

      final activateResponse = await _activateAccount(request: activateRequest);

      if ((activateResponse.status ?? '').toLowerCase() != 'success') {
        authCubit.onUpdateData(
          authCubit.state.data.copyWith(
            isOtpVerificationLoading: false,
            isOtpVerified: false,
            authErrorMessage:
                activateResponse.message ?? LocaleKeys.otpActivateFailed.tr(),
          ),
        );
        return false;
      }

      final loginRequest = AuthAfterOtpModel(mobile: phone);

      final loginResponse = await _loginAfterOtp(request: loginRequest);

      if ((loginResponse.token ?? '').isEmpty) {
        authCubit.onUpdateData(
          authCubit.state.data.copyWith(
            isOtpVerificationLoading: false,
            isOtpVerified: false,
            authErrorMessage: LocaleKeys.otpLoginFailed.tr(),
          ),
        );
        return false;
      }

      await _saveOtpSession(phone: phone, response: loginResponse);

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
          authErrorMessage: errorMessageFrom(e),
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
          authErrorMessage: LocaleKeys.otpResendPhoneMissing.tr(),
        ),
      );
      return false;
    }

    return startPhoneAuth(phone);
  }
}
