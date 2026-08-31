import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/models/response/splash/startup_model.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/services/cart_service.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:almasry_2/core/services/user_profile_service.dart';

class AppStartupService {
  final SharedPrefsServices _prefs = sl<SharedPrefsServices>();

  final GenericCubit<StartupStatus> splashCubit = GenericCubit<StartupStatus>(
    StartupStatus.initial,
  );

  Future<StartupStatus> checkAppStart() async {
    final bool isFirstTime = _prefs.getBool(
      PrefKeys.isFirstTime,
      defaultValue: true,
    );

    final bool isLoggedIn = _prefs.getBool(
      PrefKeys.isLoggedIn,
      defaultValue: false,
    );

    final StartupStatus status;

    if (isFirstTime) {
      status = StartupStatus.firstTime;
    } else if (isLoggedIn) {
      status = StartupStatus.authenticated;
    } else {
      status = StartupStatus.unauthenticated;
    }

    splashCubit.onUpdateData(status);

    return status;
  }

  Future<void> completeFirstTime() async {
    await _prefs.setBool(PrefKeys.isFirstTime, false);

    splashCubit.onUpdateData(StartupStatus.unauthenticated);
  }

  Future<void> saveLoggedIn() async {
    await _prefs.setBool(PrefKeys.isLoggedIn, true);
    await _prefs.setBool(PrefKeys.isFirstTime, false);

    splashCubit.onUpdateData(StartupStatus.authenticated);
  }

  Future<void> logout() async {
    await _prefs.setBool(PrefKeys.isLoggedIn, false);

    await _prefs.remove(PrefKeys.customerToken);

    await sl<CartService>().clearForLogout();

    await sl<UserProfileService>().clear();

    splashCubit.onUpdateData(StartupStatus.unauthenticated);
  }

  void dispose() {
    splashCubit.close();
  }
}
