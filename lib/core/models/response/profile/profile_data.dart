part of '../../../../features/profile/profile_imports.dart';

class ProfileData {
  final bool isGuest;
  final String currentLanguageCode;

  const ProfileData({
    required this.isGuest,
    required this.currentLanguageCode,
  });

  ProfileData copyWith({
    bool? isGuest,
    String? currentLanguageCode,
  }) {
    return ProfileData(
      isGuest: isGuest ?? this.isGuest,
      currentLanguageCode: currentLanguageCode ?? this.currentLanguageCode,
    );
  }
}
