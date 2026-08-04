part of '../edit_profile_imports.dart';

class EditProfileViewModel {
  /// Services

  final NavigationService _nav = sl<NavigationService>();

  /// Variables

  final GenericCubit<EditProfileModel> _editProfileCubit =
      GenericCubit<EditProfileModel>(EditProfileModel.initial());

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _diseaseTypeController;

  EditProfileModel get _data => _editProfileCubit.state.data;

  /// Init

  void _init(EditProfileArgs? args) {
    _seedFromArgs(args);

    final data = _editProfileCubit.state.data;

    _firstNameController = TextEditingController(text: data.firstName);
    _lastNameController = TextEditingController(text: data.lastName);
    _emailController = TextEditingController(text: data.email);
    _phoneController = TextEditingController(text: data.phone);
    _birthDateController = TextEditingController(text: data.birthDate);
    _diseaseTypeController = TextEditingController(text: data.diseaseType);
  }

  void _seedFromArgs(EditProfileArgs? args) {
    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(
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

  void _dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _diseaseTypeController.dispose();
    _editProfileCubit.close();
  }

  /// Form state

  void _updateFirstName(String value) {
    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(
        firstName: value,
        saveSuccess: false,
      ),
    );
  }

  void _updateLastName(String value) {
    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(
        lastName: value,
        saveSuccess: false,
      ),
    );
  }

  void _updateEmail(String value) {
    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(email: value, saveSuccess: false),
    );
  }

  void _updatePhone(String value) {
    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(phone: value, saveSuccess: false),
    );
  }

  void _updateGender(String value) {
    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(gender: value, saveSuccess: false),
    );
  }

  void _updateBirthDate(String value) {
    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(
        birthDate: value,
        saveSuccess: false,
      ),
    );
  }

  void _updateHasPregnancy(String value) {
    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(
        hasPregnancy: value,
        saveSuccess: false,
      ),
    );
  }

  void _updateChronicDisease(String value) {
    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(
        chronicDisease: value,
        saveSuccess: false,
      ),
    );
  }

  void _updateDiseaseType(String value) {
    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(
        diseaseType: value,
        saveSuccess: false,
      ),
    );
  }

  /// Dropdown options

  List<DropdownMenuItem<String>> _yesNoItems() {
    return [
      DropdownMenuItem(value: 'yes', child: Text(LocaleKeys.yes.tr())),
      DropdownMenuItem(value: 'no', child: Text(LocaleKeys.no.tr())),
    ];
  }

  List<DropdownMenuItem<String>> _genderItems() {
    return [
      DropdownMenuItem(value: 'male', child: Text(LocaleKeys.male.tr())),
      DropdownMenuItem(value: 'female', child: Text(LocaleKeys.female.tr())),
    ];
  }

  /// Actions

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1940),
      lastDate: now,
    );

    if (picked != null) {
      final String formatted =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';

      _birthDateController.text = formatted;
      _updateBirthDate(formatted);
    }
  }

  void _goBack() {
    _nav.pop();
  }

  void _onStateChanged(EditProfileModel data) {
    if (data.saveSuccess) {
      _nav.pop(
        EditProfileArgs(
          firstName: data.firstName,
          lastName: data.lastName,
          email: data.email,
          phone: data.phone,
          gender: data.gender,
          birthDate: data.birthDate,
          hasPregnancy: data.hasPregnancy,
          chronicDisease: data.chronicDisease,
          diseaseType: data.diseaseType,
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(
        isSaving: true,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    _editProfileCubit.onUpdateData(
      _editProfileCubit.state.data.copyWith(isSaving: false, saveSuccess: true),
    );
  }
}
