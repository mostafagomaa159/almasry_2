part of '../profile_imports.dart';

class ProfileViewModel {
  /// Services

  final NavigationService _nav = sl<NavigationService>();
  final AppStartupService _startup = sl<AppStartupService>();
  final SharedPrefsServices _prefs = sl<SharedPrefsServices>();

  /// Variables

  final GenericCubit<ProfileData> _profileCubit;

  final GenericCubit<ProfileArgs> _currentProfileCubit =
      GenericCubit<ProfileArgs>(const ProfileArgs(source: ''));

  final GenericCubit<String> _appVersionCubit = GenericCubit<String>('');

  final ProfileArgs? _args;

  ProfileViewModel({ProfileArgs? args})
    : _args = args,
      _profileCubit = GenericCubit<ProfileData>(
        ProfileData(isGuest: args?.isGuest == true, currentLanguageCode: 'en'),
      );

  ProfileData _data() => _profileCubit.state.data;

  ProfileArgs _currentProfile() => _currentProfileCubit.state.data;

  /// Init

  void _initLanguage(BuildContext context) {
    _profileCubit.onUpdateData(
      _profileCubit.state.data.copyWith(
        currentLanguageCode: context.locale.languageCode,
      ),
    );
  }

  void _initAccount() {
    _currentProfileCubit.onUpdateData(
      ProfileArgs(
        firstName: _args?.firstName,
        lastName: _args?.lastName,
        email: _args?.email,
        phone: _args?.phone,
        gender: _args?.gender,
        birthDate: _args?.birthDate,
        hasPregnancy: _args?.hasPregnancy,
        chronicDisease: _args?.chronicDisease,
        diseaseType: _args?.diseaseType,
        source: '',
      ),
    );

    _mergeSavedProfileData();
  }

  void _mergeSavedProfileData() {
    final String savedEmail = _prefs.getString(PrefKeys.email);
    final String savedPhone = _prefs.getString(PrefKeys.phone);
    final String savedFirstName = _prefs.getString(PrefKeys.firstName);
    final String savedLastName = _prefs.getString(PrefKeys.lastName);

    final current = _currentProfile();

    _currentProfileCubit.onUpdateData(
      ProfileArgs(
        firstName: current.firstName?.trim().isNotEmpty == true
            ? current.firstName
            : (savedFirstName.isNotEmpty ? savedFirstName : null),
        lastName: current.lastName?.trim().isNotEmpty == true
            ? current.lastName
            : (savedLastName.isNotEmpty ? savedLastName : null),
        email: current.email?.trim().isNotEmpty == true
            ? current.email
            : (savedEmail.isNotEmpty ? savedEmail : null),
        phone: current.phone?.trim().isNotEmpty == true
            ? current.phone
            : (savedPhone.isNotEmpty ? savedPhone : null),
        gender: current.gender,
        birthDate: current.birthDate,
        hasPregnancy: current.hasPregnancy,
        chronicDisease: current.chronicDisease,
        diseaseType: current.diseaseType,
        source: current.source,
      ),
    );
  }

  Future<void> _initGuest() async {
    final packageInfo = await PackageInfo.fromPlatform();

    _appVersionCubit.onUpdateData(packageInfo.version);
  }

  void _dispose() {
    _profileCubit.close();
    _currentProfileCubit.close();
    _appVersionCubit.close();
  }

  /// Display values

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

  /// Language

  Future<void> _changeLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    if (_profileCubit.state.data.currentLanguageCode == languageCode) return;

    await AppLocale.setLanguage(context, languageCode);

    _profileCubit.onUpdateData(
      _profileCubit.state.data.copyWith(currentLanguageCode: languageCode),
    );
  }

  Future<void> _toggleLanguage(BuildContext context) async {
    final String newLanguageCode =
        _profileCubit.state.data.currentLanguageCode == 'ar' ? 'en' : 'ar';

    await _changeLanguage(context, newLanguageCode);
  }

  /// Actions

  void _onBackTap() {
    if (_nav.canPop) {
      _nav.pop();
    } else {
      _nav.goNamed(RouteNames.home);
    }
  }

  void _openOrders() {
    final email = _currentProfile().email?.trim();

    if (email == null || email.isEmpty) return;

    _nav.pushNamed(RouteNames.orders, extra: email);
  }

  void _openWishlist() {
    _nav.pushNamed(RouteNames.wishlist);
  }

  void _goToLogin() {
    _nav.goNamed(RouteNames.login);
  }

  Future<void> _openEditProfile() async {
    final Object? result = await _nav.pushNamedAndReturn(
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
      await _prefs.setString(PrefKeys.firstName, result.firstName ?? '');
      await _prefs.setString(PrefKeys.lastName, result.lastName ?? '');
      await _prefs.setString(PrefKeys.email, result.email ?? '');
      await _prefs.setString(PrefKeys.phone, result.phone ?? '');

      _currentProfileCubit.onUpdateData(
        ProfileArgs(
          firstName: result.firstName,
          lastName: result.lastName,
          email: result.email,
          phone: result.phone,
          gender: result.gender,
          birthDate: result.birthDate,
          hasPregnancy: result.hasPregnancy,
          chronicDisease: result.chronicDisease,
          diseaseType: result.diseaseType,
          source: '',
        ),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _prefs.remove(PrefKeys.isLoggedIn);
    await _prefs.remove(PrefKeys.email);
    await _prefs.remove(PrefKeys.phone);
    await _prefs.remove(PrefKeys.firstName);
    await _prefs.remove(PrefKeys.lastName);

    await _startup.logout();

    if (!context.mounted) return;

    _nav.goNamed(RouteNames.login);
  }
}
