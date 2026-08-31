part of '../edit_profile_imports.dart';

class EditProfileViewModel {
  final _navService = sl<NavigationService>();

  final GenericCubit<String> _genderCubit = GenericCubit<String>('');
  final GenericCubit<String> _hasPregnancyCubit = GenericCubit<String>('');
  final GenericCubit<String> _chronicDiseaseCubit = GenericCubit<String>('');

  final GenericCubit<bool> _savingCubit = GenericCubit<bool>(false);

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phone = '';
  String _birthDate = '';
  String _diseaseType = '';

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _diseaseTypeController;

  void _init(EditProfileArgs? args) {
    _seedFromArgs(args);

    _firstNameController = TextEditingController(text: _firstName);
    _lastNameController = TextEditingController(text: _lastName);
    _emailController = TextEditingController(text: _email);
    _phoneController = TextEditingController(text: _phone);
    _birthDateController = TextEditingController(text: _birthDate);
    _diseaseTypeController = TextEditingController(text: _diseaseType);
  }

  void _seedFromArgs(EditProfileArgs? args) {
    _firstName = args?.firstName ?? '';
    _lastName = args?.lastName ?? '';
    _email = args?.email ?? '';
    _phone = args?.phone ?? '';
    _birthDate = args?.birthDate ?? '';
    _diseaseType = args?.diseaseType ?? '';

    _genderCubit.onUpdateData(args?.gender ?? '');
    _hasPregnancyCubit.onUpdateData(args?.hasPregnancy ?? '');
    _chronicDiseaseCubit.onUpdateData(args?.chronicDisease ?? '');
  }

  void _dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _diseaseTypeController.dispose();

    _genderCubit.close();
    _hasPregnancyCubit.close();
    _chronicDiseaseCubit.close();
    _savingCubit.close();
  }

  void _updateFirstName(String value) => _firstName = value;

  void _updateLastName(String value) => _lastName = value;

  void _updateEmail(String value) => _email = value;

  void _updatePhone(String value) => _phone = value;

  void _updateBirthDate(String value) => _birthDate = value;

  void _updateDiseaseType(String value) => _diseaseType = value;

  void _updateGender(String value) => _genderCubit.onUpdateData(value);

  void _updateHasPregnancy(String value) =>
      _hasPregnancyCubit.onUpdateData(value);

  void _updateChronicDisease(String value) =>
      _chronicDiseaseCubit.onUpdateData(value);

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
    _navService.pop();
  }

  Future<void> _saveProfile() async {
    if (_savingCubit.state.data) return;

    _savingCubit.onUpdateData(true);

    await Future.delayed(AppDurations.savePause);

    _savingCubit.onUpdateData(false);

    _navService.pop(
      EditProfileArgs(
        firstName: _firstName,
        lastName: _lastName,
        email: _email,
        phone: _phone,
        gender: _genderCubit.state.data,
        birthDate: _birthDate,
        hasPregnancy: _hasPregnancyCubit.state.data,
        chronicDisease: _chronicDiseaseCubit.state.data,
        diseaseType: _diseaseType,
      ),
    );
  }
}
