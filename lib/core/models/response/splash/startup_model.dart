part of '../../../../features/splash/splash_imports.dart';

enum StartupStatus {
  initial,
  firstTime,
  authenticated,
  unauthenticated,
}

class StartupData {
  final StartupStatus status;

  const StartupData({
    this.status = StartupStatus.initial,
  });

  StartupData copyWith({
    StartupStatus? status,
  }) {
    return StartupData(
      status: status ?? this.status,
    );
  }
}
