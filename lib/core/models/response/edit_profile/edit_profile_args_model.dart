class EditProfileArgs {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? birthDate;
  final String? hasPregnancy;
  final String? chronicDisease;
  final String? diseaseType;

  const EditProfileArgs({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.birthDate,
    this.hasPregnancy,
    this.chronicDisease,
    this.diseaseType,
  });
}