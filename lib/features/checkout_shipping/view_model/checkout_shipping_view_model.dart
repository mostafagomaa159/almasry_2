part of '../checkout_shipping_imports.dart';

typedef ListAddresses = List<AddressModel>;
typedef ListShippingMethods = List<ShippingMethodModel>;

class CheckoutShippingViewModel {
  final _graphqlService = sl<GraphQLService>();
  final _navService = sl<NavigationService>();
  final _alertService = sl<AlertService>();
  final _cartService = sl<CartService>();
  final _addressBookService = sl<AddressBookService>();
  final _checkoutFlowService = sl<CheckoutFlowService>();
  final _prefsService = sl<SharedPrefsServices>();

  final GenericCubit<String> _selectedAddressIdCubit = GenericCubit<String>('');

  final GenericCubit<bool> _showAllAddressesCubit = GenericCubit<bool>(false);

  final GenericCubit<ListShippingMethods> _methodsCubit =
      GenericCubit<ListShippingMethods>([]);

  final GenericCubit<String> _selectedMethodKeyCubit = GenericCubit<String>('');

  final GenericCubit<bool> _applyingAddressCubit = GenericCubit<bool>(false);

  final GenericCubit<bool> _settingMethodCubit = GenericCubit<bool>(false);

  late final GenericCubit<ListAddresses> _addressesCubit =
      _addressBookService.addressesCubit;

  GenericCubit<CartModel> get _cartCubit => _cartService.cartCubit;

  String _errorMessage = '';

  CartModel _cart() => _cartService.cart;

  ListAddresses _addresses() => _addressBookService.addresses;

  ListShippingMethods _methods() => _methodsCubit.state.data;

  bool _hasAddress() => _selectedAddressIdCubit.state.data.trim().isNotEmpty;

  bool _hasMethod() => _selectedMethodKeyCubit.state.data.trim().isNotEmpty;

  Future<void> _init() async {
    await _addressBookService.load();

    final AddressModel? preselected =
        _rememberedAddress() ?? _addressBookService.defaultAddress;

    if (preselected == null) return;

    await _selectAddress(preselected);
  }

  AddressModel? _rememberedAddress() {
    final String id = _checkoutFlowService.selectedAddressId;

    if (id.isEmpty) return null;

    for (final AddressModel address in _addresses()) {
      if (address.id == id) return address;
    }

    return null;
  }

  void _toggleShowAllAddresses() {
    _showAllAddressesCubit.onUpdateData(!_showAllAddressesCubit.state.data);
  }

  Future<void> _addNewAddress() => _openAddressForm();

  Future<void> _editAddress(AddressModel address) =>
      _openAddressForm(address: address);

  Future<void> _openAddressForm({AddressModel? address}) async {
    final AddressModel? before = _selectedAddress();

    await _navService.pushNamedAndReturn(
      RouteNames.addressForm,
      extra: address == null ? null : AddressFormArgs(address: address),
    );

    final AddressModel? after =
        _selectedAddress() ?? _addressBookService.defaultAddress;

    if (after == null) return;

    if (before == after) return;

    await _selectAddress(after);
  }

  void _confirmDeleteAddress(AddressModel address) {
    _alertService.showConfirmation(
      title: LocaleKeys.checkoutDeleteAddressConfirm.tr(),
      confirmTitle: LocaleKeys.confirm.tr(),
      cancelTitle: LocaleKeys.cancel.tr(),
      onConfirm: () => _deleteAddress(address),
    );
  }

  Future<void> _deleteAddress(AddressModel address) async {
    await _addressBookService.remove(address.id);

    _alertService.showSuccess(LocaleKeys.checkoutAddressDeleted.tr());

    if (_selectedAddressIdCubit.state.data != address.id) return;

    _checkoutFlowService.selectedAddressId = '';

    _selectedAddressIdCubit.onUpdateData('');
    _selectedMethodKeyCubit.onUpdateData('');
    _methodsCubit.onUpdateData(const []);

    final AddressModel? next = _addressBookService.defaultAddress;

    if (next != null) await _selectAddress(next);
  }

  Future<void> _selectAddress(AddressModel address) async {
    _errorMessage = '';

    _checkoutFlowService.selectedAddressId = address.id;

    _selectedAddressIdCubit.onUpdateData(address.id);
    _selectedMethodKeyCubit.onUpdateData('');
    _applyingAddressCubit.onUpdateData(true);
    _methodsCubit.onUpdateData(const []);

    final String id = await _cartService.ensureCartId();

    if (id.isEmpty) {
      _fail(LocaleKeys.somethingWentWrong.tr());

      return;
    }

    try {
      await _graphqlService.mutate(
        GraphQLDocuments.setShippingAddressesOnCart,
        variables: SetShippingAddressRequest(
          cartId: id,
          address: address,
        ).toVariables(),
      );

      await _graphqlService.mutate(
        GraphQLDocuments.setBillingAddressOnCart,
        variables: SetBillingAddressRequest(
          cartId: id,
          address: address,
        ).toVariables(),
      );

      await _setGuestEmail(id);

      await _loadShippingMethods(id);
    } catch (error) {
      _fail(errorMessageFrom(error));
    }
  }

  Future<void> _setGuestEmail(String cartId) async {
    final String email = _prefsService.getString(PrefKeys.email).trim();

    if (email.isEmpty) return;

    try {
      await _graphqlService.mutate(
        GraphQLDocuments.setGuestEmailOnCart,
        variables: {'cartId': cartId, 'email': email},
      );
    } catch (_) {}
  }

  Future<void> _loadShippingMethods(String cartId) async {
    final Map<String, dynamic> response = await _graphqlService.query(
      GraphQLDocuments.getCartShippingMethods,
      variables: {'cartId': cartId},
    );

    final ListShippingMethods methods = _methodsFrom(response);

    final ShippingMethodModel? current = _selectedMethodFrom(response);

    final String selectedKey = current != null && !current.isEmpty
        ? current.key
        : (methods.isEmpty ? '' : methods.first.key);

    _errorMessage = '';

    _applyingAddressCubit.onUpdateData(false);
    _selectedMethodKeyCubit.onUpdateData(selectedKey);
    _methodsCubit.onUpdateData(methods);

    if (selectedKey.isEmpty) return;

    await _applyMethod(_methodByKey(selectedKey), silent: true);
  }

  Future<void> _selectMethod(ShippingMethodModel? method) async {
    if (method == null || method.isEmpty) return;
    if (method.key == _selectedMethodKeyCubit.state.data &&
        _cart().shippingCost > 0) {
      return;
    }

    _errorMessage = '';

    _selectedMethodKeyCubit.onUpdateData(method.key);

    await _applyMethod(method);
  }

  Future<void> _applyMethod(
    ShippingMethodModel? method, {
    bool silent = false,
  }) async {
    if (method == null || method.isEmpty) return;

    _settingMethodCubit.onUpdateData(true);

    try {
      await _graphqlService.mutate(
        GraphQLDocuments.setShippingMethodsOnCart,
        variables: SetShippingMethodRequest(
          cartId: _cartService.cartId,
          carrierCode: method.carrierCode,
          methodCode: method.methodCode,
        ).toVariables(),
      );

      await _cartService.loadCart();
    } catch (error) {
      if (!silent) _alertService.showError(errorMessageFrom(error));
    } finally {
      _settingMethodCubit.onUpdateData(false);
    }
  }

  Future<void> _retry() async {
    final AddressModel? address = _selectedAddress();

    if (address == null) return _init();

    await _selectAddress(address);
  }

  void _proceed() {
    if (!_hasAddress()) {
      _alertService.showError(LocaleKeys.checkoutSelectAddress.tr());

      return;
    }

    if (!_hasMethod()) {
      _alertService.showError(LocaleKeys.checkoutSelectShippingMethod.tr());

      return;
    }

    _checkoutFlowService.next();
  }

  AddressModel? _selectedAddress() {
    for (final AddressModel address in _addresses()) {
      if (address.id == _selectedAddressIdCubit.state.data) return address;
    }

    return null;
  }

  ListAddresses _visibleAddresses() {
    final AddressModel? selected = _selectedAddress();

    if (_showAllAddressesCubit.state.data) {
      if (selected == null) return _addresses();

      return <AddressModel>[
        selected,
        ..._addresses().where((AddressModel item) => item.id != selected.id),
      ];
    }

    if (selected != null) return <AddressModel>[selected];

    return _addresses().isEmpty ? const [] : <AddressModel>[_addresses().first];
  }

  ShippingMethodModel? _methodByKey(String key) {
    for (final ShippingMethodModel method in _methods()) {
      if (method.key == key) return method;
    }

    return null;
  }

  ListShippingMethods _methodsFrom(Map<String, dynamic> response) {
    return (_firstAddress(response)?['available_shipping_methods']
                as List<dynamic>? ??
            const [])
        .whereType<Map<String, dynamic>>()
        .map(ShippingMethodModel.fromJson)
        .where(
          (ShippingMethodModel method) => method.available && !method.isEmpty,
        )
        .toList();
  }

  ShippingMethodModel? _selectedMethodFrom(Map<String, dynamic> response) {
    final Map<String, dynamic>? selected =
        _firstAddress(response)?['selected_shipping_method']
            as Map<String, dynamic>?;

    return selected == null ? null : ShippingMethodModel.fromJson(selected);
  }

  Map<String, dynamic>? _firstAddress(Map<String, dynamic> response) {
    final List<Map<String, dynamic>> addresses =
        ((response['cart'] as Map<String, dynamic>?)?['shipping_addresses']
                    as List<dynamic>? ??
                const [])
            .whereType<Map<String, dynamic>>()
            .toList();

    return addresses.isEmpty ? null : addresses.first;
  }

  void _fail(String message) {
    _errorMessage = message;

    _applyingAddressCubit.onUpdateData(false);
    _settingMethodCubit.onUpdateData(false);
    _methodsCubit.onUpdateData(const []);
  }
}
