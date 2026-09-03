import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_api.dart';
import 'package:almasry_2/core/constants/app_durations.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/request/login/activate_account_model.dart';
import 'package:almasry_2/core/models/request/login/auth_after_otp_model.dart';
import 'package:almasry_2/core/models/request/login/forget_password_model.dart';
import 'package:almasry_2/core/models/response/login/activate_account_model.dart';
import 'package:almasry_2/core/models/response/login/register_customer_otp_model.dart';
import 'package:almasry_2/core/services/api_services.dart';
import 'package:almasry_2/core/services/app_startup_service.dart';
import 'package:almasry_2/core/services/cart_service.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:almasry_2/core/services/user_profile_service.dart';
import 'package:almasry_2/core/utils/error_message.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthSessionService {
  final _apiService = sl<ApiService>();
  final _prefsService = sl<SharedPrefsServices>();
  final _startupService = sl<AppStartupService>();
  final _userProfileService = sl<UserProfileService>();

  final GenericCubit<bool> passwordHiddenCubit = GenericCubit<bool>(true);
  final GenericCubit<bool> rememberMeCubit = GenericCubit<bool>(false);

  final GenericCubit<bool> loadingCubit = GenericCubit<bool>(false);
  final GenericCubit<bool> phoneAuthLoadingCubit = GenericCubit<bool>(false);
  final GenericCubit<bool> otpLoadingCubit = GenericCubit<bool>(false);

  final GenericCubit<bool> validationCubit = GenericCubit<bool>(false);

  final GenericCubit<int> otpCountdownCubit = GenericCubit<int>(
    _otpCountdownStart,
  );

  String? emailOrPhoneError;
  String? passwordError;

  String? firstNameError;
  String? lastNameError;
  String? phoneError;
  String? emailError;

  String? otpError;
  String? authErrorMessage;

  String? verificationPhone;
  String? verificationLocalPhone;
  String? verificationCode;
  String? verificationCustomerId;

  static const int _otpCountdownStart = 30;

  bool get canResendOtp => otpCountdownCubit.state.data == 0;

  bool get hasValidationError =>
      emailOrPhoneError != null ||
      passwordError != null ||
      firstNameError != null ||
      lastNameError != null ||
      phoneError != null ||
      emailError != null ||
      otpError != null ||
      authErrorMessage != null;

  void togglePasswordVisibility() {
    passwordHiddenCubit.onUpdateData(!passwordHiddenCubit.state.data);
  }

  void toggleRememberMe() {
    rememberMeCubit.onUpdateData(!rememberMeCubit.state.data);
  }

  void setLoginValidationErrors({
    String? emailOrPhoneError,
    String? passwordError,
  }) {
    this.emailOrPhoneError = emailOrPhoneError;
    this.passwordError = passwordError;

    validationCubit.onUpdateData(hasValidationError);
  }

  void clearLoginValidationErrors() {
    emailOrPhoneError = null;
    passwordError = null;
    authErrorMessage = null;

    validationCubit.onUpdateData(hasValidationError);
  }

  void setRegisterValidationErrors({
    String? firstNameError,
    String? lastNameError,
    String? phoneError,
    String? emailError,
    String? passwordError,
  }) {
    this.firstNameError = firstNameError;
    this.lastNameError = lastNameError;
    this.phoneError = phoneError;
    this.emailError = emailError;
    this.passwordError = passwordError;

    validationCubit.onUpdateData(hasValidationError);
  }

  void clearRegisterValidationErrors() {
    firstNameError = null;
    lastNameError = null;
    phoneError = null;
    emailError = null;
    passwordError = null;
    authErrorMessage = null;

    validationCubit.onUpdateData(hasValidationError);
  }

  void clearValidationErrors() {
    emailOrPhoneError = null;
    passwordError = null;
    firstNameError = null;
    lastNameError = null;
    phoneError = null;
    emailError = null;
    otpError = null;
    authErrorMessage = null;

    validationCubit.onUpdateData(hasValidationError);
  }

  void setVerificationPhone(String phone) {
    verificationPhone = phone;
    otpError = null;
    authErrorMessage = null;

    validationCubit.onUpdateData(hasValidationError);
  }

  void clearOtpState() {
    otpError = null;
    authErrorMessage = null;
    verificationPhone = null;
    verificationLocalPhone = null;
    verificationCode = null;
    verificationCustomerId = null;

    phoneAuthLoadingCubit.onUpdateData(false);
    otpLoadingCubit.onUpdateData(false);
    otpCountdownCubit.onUpdateData(_otpCountdownStart);

    validationCubit.onUpdateData(hasValidationError);
  }

  void updateOtpCountdown(int seconds) {
    otpCountdownCubit.onUpdateData(seconds);
  }

  void dispose() {
    passwordHiddenCubit.close();
    rememberMeCubit.close();
    loadingCubit.close();
    phoneAuthLoadingCubit.close();
    otpLoadingCubit.close();
    validationCubit.close();
    otpCountdownCubit.close();
  }

  String _normalizePhone(String phone) {
    final cleaned = phone.trim().replaceAll(' ', '');

    if (cleaned.startsWith('+2')) return cleaned;
    if (cleaned.startsWith('2')) return '+$cleaned';
    if (cleaned.startsWith('0')) return '+2$cleaned';

    return cleaned;
  }

  String _customerIdFrom(Map<String, dynamic> response) {
    final Object? customer = response['customer'];

    final List<Object?> fields = <Object?>[
      response['customer_id'],
      response['customerId'],
      customer is Map ? customer['id'] : null,
      response['id'],
    ];

    for (final Object? field in fields) {
      final String value = (field ?? '').toString().trim();

      if (value.isNotEmpty && value != '0') return value;
    }

    return '';
  }

  List<String> _activationCandidates(String code) {
    final List<String> candidates = <String>[];

    final List<String> ordered = <String>[
      (verificationCustomerId ?? '').trim(),
      code,
    ];

    for (final String candidate in ordered) {
      if (candidate.isEmpty || candidates.contains(candidate)) continue;

      candidates.add(candidate);
    }

    return candidates;
  }

  List<String> _mobileCandidates() {
    final String local = (verificationLocalPhone ?? '').trim();
    final String normalized = (verificationPhone ?? '').trim();

    final List<String> ordered = <String>[
      local,
      normalized,
      normalized.startsWith('+') ? normalized.substring(1) : '',
    ];

    final List<String> candidates = <String>[];

    for (final String candidate in ordered) {
      if (candidate.isEmpty || candidates.contains(candidate)) continue;

      candidates.add(candidate);
    }

    return candidates;
  }

  void _failPhoneAuth(String message) {
    authErrorMessage = message;

    phoneAuthLoadingCubit.onUpdateData(false);
    validationCubit.onUpdateData(hasValidationError);
  }

  void _failOtp(String message) {
    authErrorMessage = message;

    otpLoadingCubit.onUpdateData(false);
    validationCubit.onUpdateData(hasValidationError);
  }

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

  Future<void> login() async {
    authErrorMessage = null;

    validationCubit.onUpdateData(hasValidationError);
    loadingCubit.onUpdateData(true);

    try {
      await Future.delayed(AppDurations.authStub);
    } catch (e) {
      authErrorMessage = e.toString();

      validationCubit.onUpdateData(hasValidationError);
    } finally {
      loadingCubit.onUpdateData(false);
    }
  }

  Future<void> register() async {
    authErrorMessage = null;

    validationCubit.onUpdateData(hasValidationError);
    loadingCubit.onUpdateData(true);

    try {
      await Future.delayed(AppDurations.authStub);
    } catch (e) {
      authErrorMessage = e.toString();

      validationCubit.onUpdateData(hasValidationError);
    } finally {
      loadingCubit.onUpdateData(false);
    }
  }

  Future<bool> startPhoneAuth(String phone) async {
    otpError = null;
    authErrorMessage = null;

    validationCubit.onUpdateData(hasValidationError);
    phoneAuthLoadingCubit.onUpdateData(true);

    try {
      final normalizedPhone = _normalizePhone(phone);
      final request = ForgetPasswordModel(identity: normalizedPhone);

      final response = await _forgetPassword(request: request);

      final status = (response['status'] ?? '').toString().toLowerCase();
      final code = (response['code'] ?? '').toString();

      if (status != 'success' || code.isEmpty) {
        _failPhoneAuth(
          (response['message'] ?? LocaleKeys.otpSendFailed.tr()).toString(),
        );

        return false;
      }

      verificationPhone = normalizedPhone;
      verificationLocalPhone = phone.trim().replaceAll(' ', '');
      verificationCode = code;
      verificationCustomerId = _customerIdFrom(response);

      otpCountdownCubit.onUpdateData(_otpCountdownStart);
      phoneAuthLoadingCubit.onUpdateData(false);

      return true;
    } on DioException catch (e) {
      _failPhoneAuth(errorMessageFrom(e));

      return false;
    } catch (e) {
      _failPhoneAuth(e.toString());

      return false;
    }
  }

  Future<bool> sendVerificationCode(String phone) {
    return startPhoneAuth(phone);
  }

  Future<void> _saveOtpSession({
    required String phone,
    required RegisterCustomerOtpModel response,
  }) async {
    final String email = (response.email ?? '').trim();

    await _userProfileService.save(
      phone: phone,
      email: email.isEmpty ? null : email,
    );

    final String token = (response.token ?? '').trim();

    if (token.isNotEmpty) {
      await _prefsService.setString(PrefKeys.customerToken, token);

      await sl<CartService>().adoptCustomerCart();
    }

    await _startupService.saveLoggedIn();
  }

  Future<bool> verifyOtpCode(String otp) async {
    final trimmedOtp = otp.trim();

    if (trimmedOtp.length != 5) {
      otpError = LocaleKeys.otpInvalidLength.tr();

      validationCubit.onUpdateData(hasValidationError);

      return false;
    }

    final phone = verificationPhone;
    final savedCode = verificationCode;

    if (phone == null || phone.isEmpty) {
      authErrorMessage = LocaleKeys.otpPhoneMissing.tr();

      validationCubit.onUpdateData(hasValidationError);

      return false;
    }

    if (savedCode == null || savedCode.isEmpty) {
      authErrorMessage = LocaleKeys.otpCodeMissing.tr();

      validationCubit.onUpdateData(hasValidationError);

      return false;
    }

    if (trimmedOtp != savedCode) {
      otpError = LocaleKeys.otpIncorrect.tr();
      authErrorMessage = null;

      validationCubit.onUpdateData(hasValidationError);

      return false;
    }

    otpError = null;
    authErrorMessage = null;

    validationCubit.onUpdateData(hasValidationError);
    otpLoadingCubit.onUpdateData(true);

    try {
      bool activated = false;
      String activateFailure = '';

      for (final String customerId in _activationCandidates(savedCode)) {
        try {
          final ActivateAccountModel attempt = await _activateAccount(
            request: ActivateAccountRequest(customerId: customerId),
          );

          if ((attempt.status ?? '').toLowerCase() == 'success') {
            activated = true;

            break;
          }

          activateFailure = (attempt.message ?? '').trim();
        } on DioException catch (e) {
          activateFailure = errorMessageFrom(e);
        }
      }

      if (!activated) {
        _failOtp(
          activateFailure.isEmpty
              ? LocaleKeys.otpActivateFailed.tr()
              : activateFailure,
        );

        return false;
      }

      RegisterCustomerOtpModel? loginResponse;
      String loginFailure = '';

      for (final String mobile in _mobileCandidates()) {
        try {
          final RegisterCustomerOtpModel attempt = await _loginAfterOtp(
            request: AuthAfterOtpModel(mobile: mobile),
          );

          if ((attempt.token ?? '').isNotEmpty) {
            loginResponse = attempt;

            break;
          }

          loginFailure = (attempt.message ?? '').trim();
        } on DioException catch (e) {
          loginFailure = errorMessageFrom(e);
        }
      }

      if (loginResponse == null) {
        _failOtp(
          loginFailure.isEmpty ? LocaleKeys.otpLoginFailed.tr() : loginFailure,
        );

        return false;
      }

      await _saveOtpSession(phone: phone, response: loginResponse);

      otpLoadingCubit.onUpdateData(false);

      return true;
    } on DioException catch (e) {
      _failOtp(errorMessageFrom(e));

      return false;
    } catch (e) {
      _failOtp(e.toString());

      return false;
    }
  }

  Future<bool> resendVerificationCode() async {
    final phone = verificationPhone;

    if (phone == null || phone.isEmpty) {
      authErrorMessage = LocaleKeys.otpResendPhoneMissing.tr();

      validationCubit.onUpdateData(hasValidationError);

      return false;
    }

    return startPhoneAuth(phone);
  }
}
