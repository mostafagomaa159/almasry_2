part of '../checkout_shipping_imports.dart';

typedef ListAddresses = List<AddressModel>;
typedef ListShippingMethods = List<ShippingMethodModel>;

/// Step one of the checkout: choose the shipping address, push it onto the
/// cart, and pick from the shipping methods Magento quotes back for it.
///
/// The order matters and is not negotiable — Magento only quotes shipping
/// methods for a cart that already has a shipping address, and only accepts a
/// payment method once a shipping method is set. So picking an address fires
/// three calls behind one spinner: set shipping address, set billing address,
/// re-read the available methods.
class CheckoutShippingViewModel {
  final GraphQLService _graphqlService = sl<GraphQLService>();
  final NavigationService _navService = sl<NavigationService>();
  final AlertService _alertService = sl<AlertService>();
  final CartService _cartService = sl<CartService>();
  final AddressBookService _addressBookService = sl<AddressBookService>();
  final SharedPrefsServices _prefsService = sl<SharedPrefsServices>();

  /// The address the cart is being quoted for. Empty before one is picked, and
  /// before the address book has finished loading.
  final GenericCubit<String> _selectedAddressIdCubit = GenericCubit<String>('');

  /// Collapsed, the design shows only the chosen card behind a
  /// "Show all addresses" link.
  final GenericCubit<bool> _showAllAddressesCubit = GenericCubit<bool>(false);

  final GenericCubit<ListShippingMethods> _methodsCubit =
      GenericCubit<ListShippingMethods>([]);

  /// `carrier_code|method_code` — see `ShippingMethodModel.key`.
  final GenericCubit<String> _selectedMethodKeyCubit = GenericCubit<String>('');

  /// True while the address is being pushed onto the cart and its methods
  /// re-quoted, which is one visible step even though it is three calls.
  final GenericCubit<bool> _applyingAddressCubit = GenericCubit<bool>(false);

  final GenericCubit<bool> _settingMethodCubit = GenericCubit<bool>(false);

  late final GenericCubit<ListAddresses> _addressesCubit =
      _addressBookService.addressesCubit;

  late final GenericCubit<CartData> _cartCubit = _cartService.cartCubit;

  /// A failed address apply takes the whole step, so this is what the body
  /// swaps its content for. Always set alongside an emit on [_methodsCubit],
  /// which is what makes the screen rebuild.
  String _errorMessage = '';

  CartModel _cartModel() => _cartService.cart;

  ListAddresses _addresses() => _addressBookService.addresses;

  ListShippingMethods _methods() => _methodsCubit.state.data;

  bool _hasAddress() => _selectedAddressIdCubit.state.data.trim().isNotEmpty;

  bool _hasMethod() => _selectedMethodKeyCubit.state.data.trim().isNotEmpty;

  Future<void> _init() async {
    await _addressBookService.load();

    final AddressModel? preselected = _addressBookService.defaultAddress;

    if (preselected == null) return;

    await _selectAddress(preselected);
  }

  void _dispose() {
    _selectedAddressIdCubit.close();
    _showAllAddressesCubit.close();
    _methodsCubit.close();
    _selectedMethodKeyCubit.close();
    _applyingAddressCubit.close();
    _settingMethodCubit.close();
  }

  void _back() {
    _navService.pop();
  }

  void _toggleShowAllAddresses() {
    _showAllAddressesCubit.onUpdateData(!_showAllAddressesCubit.state.data);
  }

  Future<void> _addNewAddress() => _openAddressForm();

  Future<void> _editAddress(AddressModel address) =>
      _openAddressForm(address: address);

  /// Waits for the form to close, then reconciles the quote with the book.
  ///
  /// The address card list updates itself — it watches `AddressBookService` —
  /// but the *cart* does not: the first address ever saved has to become the
  /// selection, and an edit to the selected one has to be re-sent, because
  /// Magento is still quoting the old street.
  Future<void> _openAddressForm({AddressModel? address}) async {
    final AddressModel? before = _selectedAddress();

    await _navService.pushNamedAndReturn(
      RouteNames.addressForm,
      extra: address == null ? null : AddressFormArgs(address: address),
    );

    final AddressModel? after =
        _selectedAddress() ?? _addressBookService.defaultAddress;

    if (after == null) return;

    // Equality ignores the default flag, so saving an unrelated address — or
    // cancelling out of the form — costs nothing.
    if (before == after) return;

    await _selectAddress(after);
  }

  Future<void> _deleteAddress(AddressModel address) async {
    await _addressBookService.remove(address.id);

    if (_selectedAddressIdCubit.state.data != address.id) return;

    // The quote belonged to the address that just went away, so it has to be
    // dropped rather than left on screen against a different address.
    _selectedAddressIdCubit.onUpdateData('');
    _selectedMethodKeyCubit.onUpdateData('');
    _methodsCubit.onUpdateData(const []);

    final AddressModel? next = _addressBookService.defaultAddress;

    if (next != null) await _selectAddress(next);
  }

  /// Re-applies even when the same card is tapped again: the address may have
  /// just been edited, and the quote has to follow it.
  Future<void> _selectAddress(AddressModel address) async {
    _errorMessage = '';

    _selectedAddressIdCubit.onUpdateData(address.id);
    _selectedMethodKeyCubit.onUpdateData('');
    _applyingAddressCubit.onUpdateData(true);
    _methodsCubit.onUpdateData(const []);

    final String cartId = await _cartService.ensureCartId();

    if (cartId.isEmpty) {
      _fail(_cartService.data.errorMessage);

      return;
    }

    try {
      await _graphqlService.mutate(
        GraphQLDocuments.setShippingAddressesOnCart,
        variables: SetShippingAddressRequest(
          cartId: cartId,
          address: address,
        ).toVariables(),
      );

      // The design has no separate billing step, so the shipping address is
      // replayed as the billing one — `placeOrder` rejects a cart without it.
      await _graphqlService.mutate(
        GraphQLDocuments.setBillingAddressOnCart,
        variables: SetBillingAddressRequest(
          cartId: cartId,
          address: address,
        ).toVariables(),
      );

      await _setGuestEmail(cartId);

      await _loadShippingMethods(cartId);
    } catch (error) {
      _fail(errorMessageFrom(error));
    }
  }

  /// Magento wants an email on a guest cart before `placeOrder` will run, so
  /// the account's is sent along with the address when there is one — the OTP
  /// login persists whatever the customer record carries, and the profile's
  /// email field writes the same key.
  ///
  /// Nothing here gates the step and nothing here reports: this screen no
  /// longer decides whether the cart is orderable. If Magento still refuses at
  /// `placeOrder`, its own words are what the review screen shows.
  Future<void> _setGuestEmail(String cartId) async {
    final String email = _prefsService.getString(PrefKeys.email).trim();

    if (email.isEmpty) return;

    try {
      await _graphqlService.mutate(
        GraphQLDocuments.setGuestEmailOnCart,
        variables: {'cartId': cartId, 'email': email},
      );
    } catch (_) {
      // Magento validates the format, so a bad stored address lands here. It
      // is not this step's business — carry on to the shipping methods.
    }
  }

  Future<void> _loadShippingMethods(String cartId) async {
    final Map<String, dynamic> response = await _graphqlService.query(
      GraphQLDocuments.getCartShippingMethods,
      variables: {'cartId': cartId},
    );

    final ListShippingMethods methods = _methodsFrom(response);

    // Magento may already hold a method from an earlier visit; honour it so
    // the radio matches the cart, otherwise take the first quote.
    final ShippingMethodModel? current = _selectedMethodFrom(response);

    final String selectedKey = current != null && !current.isEmpty
        ? current.key
        : (methods.isEmpty ? '' : methods.first.key);

    _errorMessage = '';

    _applyingAddressCubit.onUpdateData(false);
    _selectedMethodKeyCubit.onUpdateData(selectedKey);
    _methodsCubit.onUpdateData(methods);

    if (selectedKey.isEmpty) return;

    // The totals need the carrier's price, which only lands on the cart once
    // the method is actually set.
    await _applyMethod(_methodByKey(selectedKey), silent: true);
  }

  Future<void> _selectMethod(ShippingMethodModel? method) async {
    if (method == null || method.isEmpty) return;
    if (method.key == _selectedMethodKeyCubit.state.data &&
        _cartModel().shippingCost > 0) {
      return;
    }

    _errorMessage = '';

    _selectedMethodKeyCubit.onUpdateData(method.key);

    await _applyMethod(method);
  }

  /// [silent] keeps the automatic first-quote apply from flashing an error
  /// toast on a screen the user has not touched yet.
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

      // Re-read rather than trust the mutation's slim selection: the grand
      // total now includes delivery and the totals card reads it off the cart.
      await _cartService.refresh();
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

    _navService.pushNamed(RouteNames.checkoutPayment);
  }

  AddressModel? _selectedAddress() {
    for (final AddressModel address in _addresses()) {
      if (address.id == _selectedAddressIdCubit.state.data) return address;
    }

    return null;
  }

  /// Collapsed the list shows the chosen card alone; expanded it shows the
  /// whole book with the chosen one first.
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

  /// The message plus the emit that shows it: the body reads [_errorMessage]
  /// inside its builder on [_methodsCubit].
  void _fail(String message) {
    _errorMessage = message;

    _applyingAddressCubit.onUpdateData(false);
    _settingMethodCubit.onUpdateData(false);
    _methodsCubit.onUpdateData(const []);
  }
}
