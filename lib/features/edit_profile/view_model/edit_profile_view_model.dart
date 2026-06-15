part of '../edit_profile_imports.dart';

class EditProfileViewModel {
  final GenericCubit<EditProfileModel> editProfileCubit =
  GenericCubit<EditProfileModel>(EditProfileModel.initial());

  void initialize(EditProfileArgs? args) {
    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        firstName: args?.firstName ?? '',
        lastName: args?.lastName ?? '',
        email: args?.email ?? '',
        phone: args?.phone ?? '',
        gender: args?.gender ?? '',
        birthDate: args?.birthDate ?? '',
        hasPregnancy: args?.hasPregnancy ?? '',
        chronicDisease: args?.chronicDisease ?? '',
        diseaseType: args?.diseaseType ?? '',
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
  }

  void updateFirstName(String value) {
    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        firstName: value,
        saveSuccess: false,
      ),
    );
  }

  void updateLastName(String value) {
    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        lastName: value,
        saveSuccess: false,
      ),
    );
  }

  void updateEmail(String value) {
    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        email: value,
        saveSuccess: false,
      ),
    );
  }

  void updatePhone(String value) {
    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        phone: value,
        saveSuccess: false,
      ),
    );
  }

  void updateGender(String value) {
    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        gender: value,
        saveSuccess: false,
      ),
    );
  }

  void updateBirthDate(String value) {
    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        birthDate: value,
        saveSuccess: false,
      ),
    );
  }

  void updateHasPregnancy(String value) {
    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        hasPregnancy: value,
        saveSuccess: false,
      ),
    );
  }

  void updateChronicDisease(String value) {
    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        chronicDisease: value,
        saveSuccess: false,
      ),
    );
  }

  void updateDiseaseType(String value) {
    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        diseaseType: value,
        saveSuccess: false,
      ),
    );
  }

  Future<void> saveProfile() async {
    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        isSaving: true,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    editProfileCubit.onUpdateData(
      editProfileCubit.state.data.copyWith(
        isSaving: false,
        saveSuccess: true,
      ),
    );
  }

  void dispose() {
    editProfileCubit.close();
  }
}
