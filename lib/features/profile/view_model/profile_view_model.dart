part of '../profile_imports.dart';

class ProfileViewModel {
  final _navService = sl<NavigationService>();
  final _startupService = sl<AppStartupService>();
  final _userProfileService = sl<UserProfileService>();

  final GenericCubit<String> _languageCodeCubit = GenericCubit<String>('en');

  final GenericCubit<ProfileArgs> _currentProfileCubit =
      GenericCubit<ProfileArgs>(const ProfileArgs(source: ''));

  final GenericCubit<String> _appVersionCubit = GenericCubit<String>('');

  final ProfileArgs? _args;

  ProfileViewModel({ProfileArgs? args})
    : _args = args,
      _isGuest = args?.isGuest == true || !sl<UserProfileService>().isSignedIn;

  final bool _isGuest;

  String _languageCode() => _languageCodeCubit.state.data;

  ProfileArgs _currentProfile() => _currentProfileCubit.state.data;

  void _initLanguage(BuildContext context) {
    _languageCodeCubit.onUpdateData(context.locale.languageCode);
  }

  void _initAccount() {
    _currentProfileCubit.onUpdateData(
      ProfileArgs(
        firstName: _stored(_userProfileService.firstName, _args?.firstName),
        lastName: _stored(_userProfileService.lastName, _args?.lastName),
        email: _stored(_userProfileService.email, _args?.email),
        phone: _stored(_userProfileService.phone, _args?.phone),
        gender: _stored(_userProfileService.gender, _args?.gender),
        birthDate: _stored(_userProfileService.birthDate, _args?.birthDate),
        hasPregnancy: _stored(
          _userProfileService.hasPregnancy,
          _args?.hasPregnancy,
        ),
        chronicDisease: _stored(
          _userProfileService.chronicDisease,
          _args?.chronicDisease,
        ),
        diseaseType: _stored(
          _userProfileService.diseaseType,
          _args?.diseaseType,
        ),
        source: '',
      ),
    );
  }

  String? _stored(String value, String? fromArgs) {
    if (value.trim().isNotEmpty) return value.trim();

    final String fallback = fromArgs?.trim() ?? '';

    return fallback.isEmpty ? null : fallback;
  }

  Future<void> _initGuest() async {
    final packageInfo = await PackageInfo.fromPlatform();

    _appVersionCubit.onUpdateData(packageInfo.version);
  }

  void _dispose() {
    _languageCodeCubit.close();
    _currentProfileCubit.close();
    _appVersionCubit.close();
  }

  String _displayName() {
    final String? firstName = _currentProfile().firstName?.trim();
    final String? lastName = _currentProfile().lastName?.trim();

    final List<String> parts = [
      if (firstName != null && firstName.isNotEmpty) firstName,
      if (lastName != null && lastName.isNotEmpty) lastName,
    ];

    if (parts.isNotEmpty) {
      return parts.join(' ');
    }

    return LocaleKeys.profileNameNotAdded.tr();
  }

  String _displayEmail() {
    final String? email = _currentProfile().email?.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }
    return LocaleKeys.profileEmailNotAdded.tr();
  }

  String _displayPhone() {
    final String? phone = _currentProfile().phone?.trim();
    if (phone != null && phone.isNotEmpty) {
      return phone;
    }
    return LocaleKeys.profilePhoneNotAdded.tr();
  }

  String _displayGender() {
    final String? gender = _currentProfile().gender?.trim();
    if (gender != null && gender.isNotEmpty) {
      return gender;
    }
    return LocaleKeys.profileNotAdded.tr();
  }

  String _displayBirthDate() {
    final String? birthDate = _currentProfile().birthDate?.trim();
    if (birthDate != null && birthDate.isNotEmpty) {
      return birthDate;
    }
    return LocaleKeys.profileNotAdded.tr();
  }

  String _displayPregnancy() {
    final String? hasPregnancy = _currentProfile().hasPregnancy?.trim();
    if (hasPregnancy != null && hasPregnancy.isNotEmpty) {
      return hasPregnancy;
    }
    return LocaleKeys.profileNotAdded.tr();
  }

  String _displayChronicDisease() {
    final String? chronicDisease = _currentProfile().chronicDisease?.trim();
    if (chronicDisease != null && chronicDisease.isNotEmpty) {
      return chronicDisease;
    }
    return LocaleKeys.profileNotAdded.tr();
  }

  Future<void> _changeLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    if (_languageCode() == languageCode) return;

    await AppLocale.setLanguage(context, languageCode);

    _languageCodeCubit.onUpdateData(languageCode);
  }

  Future<void> _toggleLanguage(BuildContext context) async {
    final String newLanguageCode = _languageCode() == 'ar' ? 'en' : 'ar';

    await _changeLanguage(context, newLanguageCode);
  }

  void _onBackTap() {
    if (_navService.canPop) {
      _navService.pop();
    } else {
      _navService.goNamed(RouteNames.home);
    }
  }

  void _openOrders() {
    final email = _currentProfile().email?.trim();

    if (email == null || email.isEmpty) return;

    _navService.pushNamed(RouteNames.orders, extra: email);
  }

  void _openWishlist() {
    _navService.pushNamed(RouteNames.wishlist);
  }

  void _goToLogin() {
    _navService.goNamed(RouteNames.login);
  }

  Future<void> _openEditProfile() async {
    final Object? result = await _navService.pushNamedAndReturn(
      RouteNames.editProfile,
      extra: EditProfileArgs(
        firstName: _currentProfile().firstName,
        lastName: _currentProfile().lastName,
        email: _currentProfile().email,
        phone: _currentProfile().phone,
        gender: _currentProfile().gender,
        birthDate: _currentProfile().birthDate,
        hasPregnancy: _currentProfile().hasPregnancy,
        chronicDisease: _currentProfile().chronicDisease,
        diseaseType: _currentProfile().diseaseType,
      ),
    );

    if (result is EditProfileArgs) {
      await _userProfileService.save(
        firstName: result.firstName ?? '',
        lastName: result.lastName ?? '',
        email: result.email ?? '',
        phone: result.phone ?? '',
        gender: result.gender ?? '',
        birthDate: result.birthDate ?? '',
        hasPregnancy: result.hasPregnancy ?? '',
        chronicDisease: result.chronicDisease ?? '',
        diseaseType: result.diseaseType ?? '',
      );

      _initAccount();
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _startupService.logout();

    if (!context.mounted) return;

    _navService.goNamed(RouteNames.login);
  }
}
