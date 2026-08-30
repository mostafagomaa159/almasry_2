part of '../address_form_imports.dart';

typedef ListRegions = List<RegionModel>;

class AddressFormViewModel {
  final AddressBookService _addressBookService = sl<AddressBookService>();
  final GraphQLService _graphqlService = sl<GraphQLService>();
  final CacheManagerService _cacheService = sl<CacheManagerService>();
  final NavigationService _nav = sl<NavigationService>();
  final AlertService _alert = sl<AlertService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// The governorate list is the only thing on this form that has to be
  /// fetched, so these three describe that fetch alone. The text fields need
  /// no state — their controllers hold it.
  final GenericCubit<ListRegions> _regionsCubit = GenericCubit<ListRegions>([]);
  final GenericCubit<bool> _regionsLoadingCubit = GenericCubit<bool>(true);

  /// Magento's `region_id`. Null until the user picks, which is what the
  /// dropdown's validator rejects.
  final GenericCubit<int?> _selectedRegionCubit = GenericCubit<int?>(null);

  final GenericCubit<bool> _savingCubit = GenericCubit<bool>(false);

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressLineController;
  late final TextEditingController _buildingController;
  late final TextEditingController _floorController;
  late final TextEditingController _apartmentController;
  late final TextEditingController _markController;

  AddressModel? _editing;

  bool _regionsRequested = false;

  String _errorMessage = '';

  bool _isEditing() => _editing != null;

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

    _regionsCubit.close();
    _regionsLoadingCubit.close();
    _selectedRegionCubit.close();
    _savingCubit.close();
  }

  void _back() {
    _nav.pop();
  }

  String _title() {
    return _isEditing()
        ? LocaleKeys.addressFormEditTitle.tr()
        : LocaleKeys.addressFormTitle.tr();
  }

  ListRegions _regions() => _regionsCubit.state.data;

  RegionModel? _selectedRegion() {
    for (final RegionModel region in _regions()) {
      if (region.id == _selectedRegionCubit.state.data) return region;
    }

    return null;
  }

  /// Cache-first so the dropdown is populated on the frame the screen opens;
  /// the network read behind it picks up any change to the store's list.
  void _loadRegions(BuildContext context) {
    if (_regionsRequested) return;
    _regionsRequested = true;

    unawaited(_regionsApi(context.locale.languageCode));
  }

  Future<void> _regionsApi(String languageCode) async {
    final ListRegions cached = await _cacheService.getCachedData<RegionModel>(
      key: PrefKeys.cachedRegions(languageCode),
      fromJson: RegionModel.fromJson,
    );

    if (cached.isNotEmpty) _emitRegions(cached);

    try {
      final Map<String, dynamic> response = await _graphqlService.query(
        GraphQLDocuments.getCountryRegions,
        variables: {'countryCode': AddressModel.countryIsoCode},
        // The names come back in the store view's language: the default view is
        // Arabic, and `default` is the English one.
        headers: languageCode == 'ar' ? const {} : const {'store': 'default'},
      );

      final ListRegions regions = RegionModel.listFrom(response);

      if (regions.isEmpty) {
        if (cached.isEmpty) _failRegions(LocaleKeys.somethingWentWrong.tr());

        return;
      }

      _emitRegions(regions);

      await _cacheService.cacheData<RegionModel>(
        data: regions,
        key: PrefKeys.cachedRegions(languageCode),
        toJson: (RegionModel region) => region.toJson(),
      );
    } catch (error) {
      // A stale list is still a usable one, so a failed refresh behind cached
      // regions is not worth reporting.
      if (cached.isEmpty) _failRegions(errorMessageFrom(error));
    } finally {
      if (!_regionsLoadingCubit.isClosed) {
        _regionsLoadingCubit.onUpdateData(false);
      }
    }
  }

  void _emitRegions(ListRegions regions) {
    if (_regionsCubit.isClosed) return;

    _errorMessage = '';

    _regionsCubit.onUpdateData(regions);
    _selectedRegionCubit.onUpdateData(_resolveSelectedId(regions));
  }

  /// Keeps whatever is already picked, then falls back to matching the address
  /// being edited — by id first, then by code or name, so an address saved
  /// before the dropdown existed still reopens on the right governorate.
  int? _resolveSelectedId(ListRegions regions) {
    final int? current = _selectedRegionCubit.state.data;

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

  /// An empty list plus a message is what the field reads as "error".
  void _failRegions(String message) {
    if (_regionsCubit.isClosed) return;

    _errorMessage = message;

    _regionsCubit.onUpdateData(const []);
  }

  Future<void> _retryRegions(BuildContext context) async {
    _errorMessage = '';

    _regionsLoadingCubit.onUpdateData(true);
    _regionsCubit.onUpdateData(const []);

    await _regionsApi(context.locale.languageCode);
  }

  void _selectRegion(int? regionId) {
    _selectedRegionCubit.onUpdateData(regionId);
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
    if (_savingCubit.state.data) return;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    _savingCubit.onUpdateData(true);

    try {
      await _addressBookService.save(_buildAddress());

      _alert.showSuccess(LocaleKeys.addressFormSaved.tr());

      _nav.pop();
    } finally {
      // The pop above disposes this ViewModel, so the cubit may already be
      // closed by the time the save settles.
      if (!_savingCubit.isClosed) _savingCubit.onUpdateData(false);
    }
  }

  /// Editing keeps the existing id and default flag; a new entry gets a
  /// timestamp id, which is enough to be unique in a device-local list.
  AddressModel _buildAddress() {
    final AddressModel? existing = _editing;
    final RegionModel? region = _selectedRegion();

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
