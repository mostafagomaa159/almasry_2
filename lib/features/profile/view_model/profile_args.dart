
class ProfileArgs {

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final bool isGuest;
  final String source;
  final String? gender;
  final String? birthDate;
  final String? hasPregnancy;
  final String? chronicDisease;
  final String? diseaseType;

  const ProfileArgs({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.isGuest = false,
    this.gender,
    this.birthDate,
    this.hasPregnancy,
    this.chronicDisease,
    this.diseaseType,
    required this.source,

  });
}
