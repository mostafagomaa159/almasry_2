part of '../profile_imports.dart';

class AccountProfileView extends StatefulWidget {
  final ProfileArgs? args;
  final ProfileViewModel viewModel;

  const AccountProfileView({
    super.key,
    this.args,
    required this.viewModel,
  });

  @override
  State<AccountProfileView> createState() => _AccountProfileViewState();
}

class _AccountProfileViewState extends State<AccountProfileView> {
  late ProfileArgs currentProfile;

  @override
  void initState() {
    super.initState();
    currentProfile = ProfileArgs(
      firstName: widget.args?.firstName,
      lastName: widget.args?.lastName,
      email: widget.args?.email,
      phone: widget.args?.phone,
      gender: widget.args?.gender,
      birthDate: widget.args?.birthDate,
      hasPregnancy: widget.args?.hasPregnancy,
      chronicDisease: widget.args?.chronicDisease,
      diseaseType: widget.args?.diseaseType,
      source: '',
    );

    _loadSavedProfileData();
  }

  Future<void> _loadSavedProfileData() async {
    final String savedEmail = SharedPrefsServices.getString(PrefKeys.email);
    final String savedPhone = SharedPrefsServices.getString(PrefKeys.phone);
    final String savedFirstName =
    SharedPrefsServices.getString(PrefKeys.firstName);
    final String savedLastName =
    SharedPrefsServices.getString(PrefKeys.lastName);

    if (!mounted) return;

    setState(() {
      currentProfile = ProfileArgs(
        firstName: currentProfile.firstName?.trim().isNotEmpty == true
            ? currentProfile.firstName
            : (savedFirstName.isNotEmpty ? savedFirstName : null),
        lastName: currentProfile.lastName?.trim().isNotEmpty == true
            ? currentProfile.lastName
            : (savedLastName.isNotEmpty ? savedLastName : null),
        email: currentProfile.email?.trim().isNotEmpty == true
            ? currentProfile.email
            : (savedEmail.isNotEmpty ? savedEmail : null),
        phone: currentProfile.phone?.trim().isNotEmpty == true
            ? currentProfile.phone
            : (savedPhone.isNotEmpty ? savedPhone : null),
        gender: currentProfile.gender,
        birthDate: currentProfile.birthDate,
        hasPregnancy: currentProfile.hasPregnancy,
        chronicDisease: currentProfile.chronicDisease,
        diseaseType: currentProfile.diseaseType,
        source: currentProfile.source,
      );
    });
  }

  String _buildDisplayName() {
    final String? firstName = currentProfile.firstName?.trim();
    final String? lastName = currentProfile.lastName?.trim();

    final List<String> parts = [
      if (firstName != null && firstName.isNotEmpty) firstName,
      if (lastName != null && lastName.isNotEmpty) lastName,
    ];

    if (parts.isNotEmpty) {
      return parts.join(' ');
    }

    return LocaleKeys.profileNameNotAdded.tr();
  }

  String _buildEmail() {
    final String? email = currentProfile.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }
    return LocaleKeys.profileEmailNotAdded.tr();
  }

  String _buildPhone() {
    final String? phone = currentProfile.phone?.trim();
    if (phone != null && phone.isNotEmpty) {
      return phone;
    }
    return LocaleKeys.profilePhoneNotAdded.tr();
  }

  String _buildGender() {
    final String? gender = currentProfile.gender?.trim();
    if (gender != null && gender.isNotEmpty) {
      return gender;
    }
    return LocaleKeys.profileNotAdded.tr();
  }

  String _buildBirthDate() {
    final String? birthDate = currentProfile.birthDate?.trim();
    if (birthDate != null && birthDate.isNotEmpty) {
      return birthDate;
    }
    return LocaleKeys.profileNotAdded.tr();
  }

  String _buildPregnancy() {
    final String? hasPregnancy = currentProfile.hasPregnancy?.trim();
    if (hasPregnancy != null && hasPregnancy.isNotEmpty) {
      return hasPregnancy;
    }
    return LocaleKeys.profileNotAdded.tr();
  }

  String _buildChronicDisease() {
    final String? chronicDisease = currentProfile.chronicDisease?.trim();
    if (chronicDisease != null && chronicDisease.isNotEmpty) {
      return chronicDisease;
    }
    return LocaleKeys.profileNotAdded.tr();
  }

  Future<void> _openEditProfile() async {
    final Object? result = await context.pushNamed(
      'editProfile',
      extra: EditProfileArgs(
        firstName: currentProfile.firstName,
        lastName: currentProfile.lastName,
        email: currentProfile.email,
        phone: currentProfile.phone,
        gender: currentProfile.gender,
        birthDate: currentProfile.birthDate,
        hasPregnancy: currentProfile.hasPregnancy,
        chronicDisease: currentProfile.chronicDisease,
        diseaseType: currentProfile.diseaseType,
      ),
    );

    if (result is EditProfileArgs) {
      await SharedPrefsServices.setString(
        PrefKeys.firstName,
        result.firstName ?? '',
      );
      await SharedPrefsServices.setString(
        PrefKeys.lastName,
        result.lastName ?? '',
      );
      await SharedPrefsServices.setString(
        PrefKeys.email,
        result.email ?? '',
      );
      await SharedPrefsServices.setString(
        PrefKeys.phone,
        result.phone ?? '',
      );

      setState(() {
        currentProfile = ProfileArgs(
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
        );
      });
    }
  }

  Future<void> _logout() async {
    await SharedPrefsServices.remove(PrefKeys.isLoggedIn);
    await SharedPrefsServices.remove(PrefKeys.email);
    await SharedPrefsServices.remove(PrefKeys.phone);
    await SharedPrefsServices.remove(PrefKeys.firstName);
    await SharedPrefsServices.remove(PrefKeys.lastName);

    await sl<SplashViewModel>().logout();

    if (!mounted) return;

    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = _buildDisplayName();
    final String email = _buildEmail();
    final String phone = _buildPhone();
    final String gender = _buildGender();
    final String birthDate = _buildBirthDate();
    final String hasPregnancy = _buildPregnancy();
    final String chronicDisease = _buildChronicDisease();
    final viewModel = widget.viewModel;

    return Container(
      color: const Color(0xFFF6F6F6),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            ProfileHeader(
              onBackTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.home);
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    ProfileInfoCard(
                      name: displayName,
                      email: email,
                      phone: phone,
                      gender: gender,
                      birthDate: birthDate,
                      hasPregnancy: hasPregnancy,
                      chronicDisease: chronicDisease,
                      onEditTap: _openEditProfile,
                    ),
                    SizedBox(height: 20.h),
                    ProfileMenuItem(
                      title: LocaleKeys.profileOrders.tr(),
                      onTap: () {
                        final email = currentProfile.email?.trim();

                        if (email == null || email.isEmpty) return;

                        context.pushNamed('orders', extra: email);
                      },
                    ),
                    ProfileMenuItem(
                      title: LocaleKeys.wishlist.tr(),
                      onTap: () {
                        context.pushNamed('wishlist');
                      },
                    ),
                    ProfileMenuItem(
                      title: LocaleKeys.profilePaymentMethods.tr(),
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      title: LocaleKeys.profileNews.tr(),
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      title: LocaleKeys.profilePointsProgram.tr(),
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      title: LocaleKeys.changeLanguage.tr(),
                      onTap: () {
                        viewModel.toggleLanguage(context);
                      },
                    ),
                    ProfileMenuItem(
                      title: LocaleKeys.log_out.tr(),
                      onTap: _logout,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
