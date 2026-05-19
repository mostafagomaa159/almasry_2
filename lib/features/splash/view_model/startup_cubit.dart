part of '../splash_imports.dart';

class StartupCubit extends Cubit<StartupState> {
  StartupCubit() : super(const StartupState());

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
      emit(state.copyWith(status: StartupStatus.firstTime));
      return;
    }

    if (isLoggedIn) {
      emit(state.copyWith(status: StartupStatus.authenticated));
      return;
    }

    emit(state.copyWith(status: StartupStatus.unauthenticated));
  }

  Future<void> completeFirstTime() async {
    await SharedPrefsHelper.setBool(PrefKeys.isFirstTime, false);
    emit(state.copyWith(status: StartupStatus.unauthenticated));
  }

  Future<void> saveLoggedIn() async {
    await SharedPrefsHelper.setBool(PrefKeys.isLoggedIn, true);
    await SharedPrefsHelper.setBool(PrefKeys.isFirstTime, false);
    emit(state.copyWith(status: StartupStatus.authenticated));
  }

  Future<void> logout() async {
    await SharedPrefsHelper.setBool(PrefKeys.isLoggedIn, false);
    emit(state.copyWith(status: StartupStatus.unauthenticated));
  }
}
