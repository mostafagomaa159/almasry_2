import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';

class UserProfileService {
  final _prefsService = sl<SharedPrefsServices>();

  String get firstName => _prefsService.getString(PrefKeys.firstName);

  String get lastName => _prefsService.getString(PrefKeys.lastName);

  String get email => _prefsService.getString(PrefKeys.email);

  String get phone => _prefsService.getString(PrefKeys.phone);

  String get gender => _prefsService.getString(PrefKeys.gender);

  String get birthDate => _prefsService.getString(PrefKeys.birthDate);

  String get hasPregnancy => _prefsService.getString(PrefKeys.hasPregnancy);

  String get chronicDisease => _prefsService.getString(PrefKeys.chronicDisease);

  String get diseaseType => _prefsService.getString(PrefKeys.diseaseType);

  bool get isSignedIn => _prefsService.getBool(PrefKeys.isLoggedIn);

  Future<void> save({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    String? birthDate,
    String? hasPregnancy,
    String? chronicDisease,
    String? diseaseType,
  }) async {
    await _write(PrefKeys.firstName, firstName);
    await _write(PrefKeys.lastName, lastName);
    await _write(PrefKeys.email, email);
    await _write(PrefKeys.phone, phone);
    await _write(PrefKeys.gender, gender);
    await _write(PrefKeys.birthDate, birthDate);
    await _write(PrefKeys.hasPregnancy, hasPregnancy);
    await _write(PrefKeys.chronicDisease, chronicDisease);
    await _write(PrefKeys.diseaseType, diseaseType);
  }

  Future<void> clear() async {
    for (final String key in _keys) {
      await _prefsService.remove(key);
    }
  }

  static const List<String> _keys = <String>[
    PrefKeys.firstName,
    PrefKeys.lastName,
    PrefKeys.email,
    PrefKeys.phone,
    PrefKeys.gender,
    PrefKeys.birthDate,
    PrefKeys.hasPregnancy,
    PrefKeys.chronicDisease,
    PrefKeys.diseaseType,
  ];

  Future<void> _write(String key, String? value) async {
    if (value == null) return;

    final String trimmed = value.trim();

    if (trimmed.isEmpty) {
      await _prefsService.remove(key);

      return;
    }

    await _prefsService.setString(key, trimmed);
  }
}
