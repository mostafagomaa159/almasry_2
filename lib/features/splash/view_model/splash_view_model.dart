part of '../splash_imports.dart';

class SplashViewModel {
  final GenericCubit<SplashData> splashCubit =
  GenericCubit<SplashData>(const SplashData());

  Future<void> checkAppStart() async {
    final bool isFirstTime = SharedPrefsServices.getBool(
      PrefKeys.isFirstTime,
      defaultValue: true,
    );

    final bool isLoggedIn = SharedPrefsServices.getBool(
      PrefKeys.isLoggedIn,
      defaultValue: false,
    );

    if (isFirstTime) {
      splashCubit.onUpdateData(
        splashCubit.state.data.copyWith(
          status: StartupStatus.firstTime,
        ),
      );
      return;
    }

    if (isLoggedIn) {
      splashCubit.onUpdateData(
        splashCubit.state.data.copyWith(
          status: StartupStatus.authenticated,
        ),
      );
      return;
    }

    splashCubit.onUpdateData(
      splashCubit.state.data.copyWith(
        status: StartupStatus.unauthenticated,
      ),
    );
  }

  Future<void> completeFirstTime() async {
    await SharedPrefsServices.setBool(PrefKeys.isFirstTime, false);

    splashCubit.onUpdateData(
      splashCubit.state.data.copyWith(
        status: StartupStatus.unauthenticated,
      ),
    );
  }

  Future<void> saveLoggedIn() async {
    await SharedPrefsServices.setBool(PrefKeys.isLoggedIn, true);
    await SharedPrefsServices.setBool(PrefKeys.isFirstTime, false);

    splashCubit.onUpdateData(
      splashCubit.state.data.copyWith(
        status: StartupStatus.authenticated,
      ),
    );
  }

  Future<void> logout() async {
    await SharedPrefsServices.setBool(PrefKeys.isLoggedIn, false);

    splashCubit.onUpdateData(
      splashCubit.state.data.copyWith(
        status: StartupStatus.unauthenticated,
      ),
    );
  }

  void dispose() {
    splashCubit.close();
  }
}
