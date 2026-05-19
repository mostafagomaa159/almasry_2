class ProfileState {
  final bool isGuest;
  final String currentLanguageCode;

  const ProfileState({
    required this.isGuest,
    required this.currentLanguageCode,
  });

  ProfileState copyWith({bool? isGuest, String? currentLanguageCode}) {
    return ProfileState(
      isGuest: isGuest ?? this.isGuest,
      currentLanguageCode: currentLanguageCode ?? this.currentLanguageCode,
    );
  }
}
