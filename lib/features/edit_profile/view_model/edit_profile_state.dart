class EditProfileState {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final String birthDate;
  final String hasPregnancy;
  final String chronicDisease;
  final String diseaseType;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final bool saveSuccess;

  const EditProfileState({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.birthDate,
    required this.hasPregnancy,
    required this.chronicDisease,
    required this.diseaseType,
    required this.isLoading,
    required this.isSaving,
    required this.errorMessage,
    required this.saveSuccess,
  });

  factory EditProfileState.initial() {
    return const EditProfileState(
      firstName: '',
      lastName: '',
      email: '',
      phone: '',
      gender: '',
      birthDate: '',
      hasPregnancy: '',
      chronicDisease: '',
      diseaseType: '',
      isLoading: false,
      isSaving: false,
      errorMessage: null,
      saveSuccess: false,
    );
  }

  EditProfileState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    String? birthDate,
    String? hasPregnancy,
    String? chronicDisease,
    String? diseaseType,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? saveSuccess,
  }) {
    return EditProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      hasPregnancy: hasPregnancy ?? this.hasPregnancy,
      chronicDisease: chronicDisease ?? this.chronicDisease,
      diseaseType: diseaseType ?? this.diseaseType,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage:
      clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }
}
