enum StartupStatus {
  initial,
  firstTime,
  authenticated,
  unauthenticated,
}

class StartupState {
  final StartupStatus status;

  const StartupState({
    this.status = StartupStatus.initial,
  });

  StartupState copyWith({
    StartupStatus? status,
  }) {
    return StartupState(
      status: status ?? this.status,
    );
  }
}
