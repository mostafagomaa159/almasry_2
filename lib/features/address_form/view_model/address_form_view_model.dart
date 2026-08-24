part of '../address_form_imports.dart';

/// Drives the add / edit address screen: the controllers, the governorate
/// list, validation, and the write into `AddressBookService`.
///
/// The book is local — Magento's customer-address API is not part of this
/// integration — so saving never leaves the device. The one thing that *is*
/// fetched is the governorate list, because Magento will not accept an address
/// without a `region_id` it recognises.
class AddressFormViewModel {
  final AddressBookService _addressBook = sl<AddressBookService>();
  final GraphQLService _graphql = sl<GraphQLService>();
  final CacheManagerService _cache = sl<CacheManagerService>();
  final NavigationService _nav = sl<NavigationService>();
  final AlertService _alert = sl<AlertService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GenericCubit<AddressFormData> _formCubit =
      GenericCubit<AddressFormData>(const AddressFormData());

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressLineController;
  late final TextEditingController _buildingController;
  late final TextEditingController _floorController;
  late final TextEditingController _apartmentController;
  late final TextEditingController _markController;

  AddressModel? _editing;

  /// The regions fetch is kicked off from `didChangeDependencies` — reading the
  /// locale needs a settled `BuildContext` — so it needs its own guard against
  /// running more than once.
  bool _regionsRequested = false;

  AddressFormData get _data => _formCubit.state.data;

  bool get _isEditing => _editing != null;

  void _init({required AddressFormArgs? args}) {
    _editing = args?.address;

    final AddressModel? address = _editing;

    _firstNameController = TextEditingController(text: address?.firstName);
    _lastNameController = TextEditingController(text: address?.lastName);
    _phoneController = TextEditingController(text: address?.phone);
    _addressLineController = TextEditingController(text: address?.addressLine);
    _buildingController = TextEditingController(text: address?.buildingNumber);
    _floorController = TextEditingController(text: address?.floor);
    _apartmentController = TextEditingController(text: address?.apartment);
    _markController = TextEditingController(text: address?.mark);
  }

  void _dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressLineController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _markController.dispose();

    _formCubit.close();
  }

  void _back() {
    _nav.pop();
  }

  String _title() {
    return _isEditing
        ? LocaleKeys.addressFormEditTitle.tr()
        : LocaleKeys.addressFormTitle.tr();
  }

  /// Cache-first so the dropdown is populated on the frame the screen opens;
  /// the network read behind it picks up any change to the store's list.
  void _loadRegions(BuildContext context) {
    if (_regionsRequested) return;
    _regionsRequested = true;

    unawaited(_regionsApi(context.locale.languageCode));
  }

  Future<void> _regionsApi(String languageCode) async {
    final List<RegionModel> cached = await _cache.getCachedData<RegionModel>(
      key: PrefKeys.cachedRegions(languageCode),
      fromJson: RegionModel.fromJson,
    );

    if (cached.isNotEmpty) _emitRegions(cached);

    try {
      final Map<String, dynamic> response = await _graphql.query(
        GraphQLDocuments.getCountryRegions,
        variables: {'countryCode': AddressModel.countryIsoCode},
        // The names come back in the store view's language: the default view is
        // Arabic, and `default` is the English one.
        headers: languageCode == 'ar' ? const {} : const {'store': 'default'},
      );

      final List<RegionModel> regions = RegionModel.listFrom(response);

      if (regions.isEmpty) {
        if (cached.isEmpty) _failRegions(LocaleKeys.somethingWentWrong.tr());

        return;
      }

      _emitRegions(regions);

      await _cache.cacheData<RegionModel>(
        data: regions,
        key: PrefKeys.cachedRegions(languageCode),
        toJson: (RegionModel region) => region.toJson(),
      );
    } catch (error) {
      // A stale list is still a usable one, so a failed refresh behind cached
      // regions is not worth reporting.
      if (cached.isEmpty) _failRegions(errorMessageFrom(error));
    }
  }

  void _emitRegions(List<RegionModel> regions) {
    _formCubit.onUpdateData(
      _data.copyWith(
        status: RegionsStatus.success,
        regions: regions,
        selectedRegionId: _resolveSelectedId(regions),
        clearErrorMessage: true,
      ),
    );
  }

  /// Keeps whatever is already picked, then falls back to matching the address
  /// being edited — by id first, then by code or name, so an address saved
  /// before the dropdown existed still reopens on the right governorate.
  int? _resolveSelectedId(List<RegionModel> regions) {
    final int? current = _data.selectedRegionId;

    if (current != null && regions.any((RegionModel r) => r.id == current)) {
      return current;
    }

    final AddressModel? address = _editing;

    if (address == null) return null;

    for (final RegionModel region in regions) {
      if (region.id == address.regionId) return region.id;
    }

    for (final RegionModel region in regions) {
      if (region.code == address.regionCode ||
          region.name == address.government ||
          region.code == address.government) {
        return region.id;
      }
    }

    return null;
  }

  void _failRegions(String message) {
    _formCubit.onUpdateData(
      _data.copyWith(status: RegionsStatus.error, errorMessage: message),
    );
  }

  Future<void> _retryRegions(BuildContext context) async {
    _formCubit.onUpdateData(
      _data.copyWith(status: RegionsStatus.loading, clearErrorMessage: true),
    );

    await _regionsApi(context.locale.languageCode);
  }

  void _selectRegion(int? regionId) {
    _formCubit.onUpdateData(
      _data.copyWith(
        selectedRegionId: regionId,
        clearSelectedRegion: regionId == null,
      ),
    );
  }

  String? _validateName(String? value) => Validators.validateName(value ?? '');

  String? _validatePhone(String? value) =>
      Validators.validatePhone(value ?? '');

  String? _validateRequired(String? value) {
    return (value ?? '').trim().isEmpty ? LocaleKeys.requiredField.tr() : null;
  }

  String? _validateRegion(int? value) {
    return value == null ? LocaleKeys.requiredField.tr() : null;
  }

  Future<void> _save() async {
    if (_data.isSaving) return;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    _formCubit.onUpdateData(_data.copyWith(isSaving: true));

    try {
      await _addressBook.save(_buildAddress());

      _alert.showSuccess(LocaleKeys.addressFormSaved.tr());

      _nav.pop();
    } finally {
      _formCubit.onUpdateData(_data.copyWith(isSaving: false));
    }
  }

  /// Editing keeps the existing id and default flag; a new entry gets a
  /// timestamp id, which is enough to be unique in a device-local list.
  AddressModel _buildAddress() {
    final AddressModel? existing = _editing;
    final RegionModel? region = _data.selectedRegion;

    return AddressModel(
      id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
      addressLine: _addressLineController.text.trim(),
      buildingNumber: _buildingController.text.trim(),
      floor: _floorController.text.trim(),
      apartment: _apartmentController.text.trim(),
      mark: _markController.text.trim(),
      government: region?.displayName ?? '',
      regionId: region?.id,
      regionCode: region?.code ?? '',
      latitude: existing?.latitude,
      longitude: existing?.longitude,
      isDefault: existing?.isDefault ?? false,
    );
  }
}
