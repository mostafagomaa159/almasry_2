/// App-startup state carried by `AppStartupService`'s cubit.
///
/// A standalone library rather than a `part`, because the splash feature and
/// the core service both need it and a `part` can only belong to one library.
enum StartupStatus { initial, firstTime, authenticated, unauthenticated }

class SplashData {
  final StartupStatus status;

  const SplashData({this.status = StartupStatus.initial});

  SplashData copyWith({StartupStatus? status}) {
    return SplashData(status: status ?? this.status);
  }
}
