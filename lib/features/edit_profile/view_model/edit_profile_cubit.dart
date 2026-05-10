import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almasry_2/features/edit_profile/edit_profile.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileState.initial());

  void initialize(EditProfileArgs? args) {
    emit(
      state.copyWith(
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
    emit(state.copyWith(firstName: value, saveSuccess: false));
  }

  void updateLastName(String value) {
    emit(state.copyWith(lastName: value, saveSuccess: false));
  }

  void updateEmail(String value) {
    emit(state.copyWith(email: value, saveSuccess: false));
  }

  void updatePhone(String value) {
    emit(state.copyWith(phone: value, saveSuccess: false));
  }

  void updateGender(String value) {
    emit(state.copyWith(gender: value, saveSuccess: false));
  }

  void updateBirthDate(String value) {
    emit(state.copyWith(birthDate: value, saveSuccess: false));
  }

  void updateHasPregnancy(String value) {
    emit(state.copyWith(hasPregnancy: value, saveSuccess: false));
  }

  void updateChronicDisease(String value) {
    emit(state.copyWith(chronicDisease: value, saveSuccess: false));
  }

  void updateDiseaseType(String value) {
    emit(state.copyWith(diseaseType: value, saveSuccess: false));
  }

  Future<void> saveProfile() async {
    emit(
      state.copyWith(
        isSaving: true,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      state.copyWith(
        isSaving: false,
        saveSuccess: true,
      ),
    );
  }
}
