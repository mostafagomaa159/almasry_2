enum StartupStatus { initial, firstTime, authenticated, unauthenticated }

class SplashData {
  final StartupStatus status;

  const SplashData({this.status = StartupStatus.initial});

  SplashData copyWith({StartupStatus? status}) {
    return SplashData(status: status ?? this.status);
  }
}
