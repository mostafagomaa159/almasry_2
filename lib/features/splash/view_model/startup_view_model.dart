part of '../splash_imports.dart';

class StartupViewModel {
  final GenericCubit<StartupData> startupCubit =
  GenericCubit<StartupData>(const StartupData());

  Future<void> checkAppStart() async {
    final bool isFirstTime = SharedPrefsHelper.getBool(
      PrefKeys.isFirstTime,
      defaultValue: true,
    );

    final bool isLoggedIn = SharedPrefsHelper.getBool(
      PrefKeys.isLoggedIn,
      defaultValue: false,
    );

    if (isFirstTime) {
      startupCubit.onUpdateData(
        startupCubit.state.data.copyWith(
          status: StartupStatus.firstTime,
        ),
      );
      return;
    }

    if (isLoggedIn) {
      startupCubit.onUpdateData(
        startupCubit.state.data.copyWith(
          status: StartupStatus.authenticated,
        ),
      );
      return;
    }

    startupCubit.onUpdateData(
      startupCubit.state.data.copyWith(
        status: StartupStatus.unauthenticated,
      ),
    );
  }

  Future<void> completeFirstTime() async {
    await SharedPrefsHelper.setBool(PrefKeys.isFirstTime, false);

    startupCubit.onUpdateData(
      startupCubit.state.data.copyWith(
        status: StartupStatus.unauthenticated,
      ),
    );
  }

  Future<void> saveLoggedIn() async {
    await SharedPrefsHelper.setBool(PrefKeys.isLoggedIn, true);
    await SharedPrefsHelper.setBool(PrefKeys.isFirstTime, false);

    startupCubit.onUpdateData(
      startupCubit.state.data.copyWith(
        status: StartupStatus.authenticated,
      ),
    );
  }

  Future<void> logout() async {
    await SharedPrefsHelper.setBool(PrefKeys.isLoggedIn, false);

    startupCubit.onUpdateData(
      startupCubit.state.data.copyWith(
        status: StartupStatus.unauthenticated,
      ),
    );
  }

  void dispose() {
    startupCubit.close();
  }
}
