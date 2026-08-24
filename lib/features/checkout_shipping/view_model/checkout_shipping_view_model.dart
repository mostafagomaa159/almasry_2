part of '../checkout_shipping_imports.dart';

/// Step one of the checkout: choose the shipping address, push it onto the
/// cart, and pick from the shipping methods Magento quotes back for it.
///
/// The order matters and is not negotiable — Magento only quotes shipping
/// methods for a cart that already has a shipping address, and only accepts a
/// payment method once a shipping method is set. So picking an address fires
/// three calls behind one spinner: set shipping address, set billing address,
/// re-read the available methods.
class CheckoutShippingViewModel {
  final GraphQLService _graphql = sl<GraphQLService>();
  final NavigationService _nav = sl<NavigationService>();
  final AlertService _alert = sl<AlertService>();
  final CartService _cart = sl<CartService>();
  final AddressBookService _addressBook = sl<AddressBookService>();
  final SharedPrefsServices _prefs = sl<SharedPrefsServices>();

  final GenericCubit<CheckoutShippingData> _shippingCubit =
      GenericCubit<CheckoutShippingData>(const CheckoutShippingData());

  GenericCubit<CheckoutShippingData> get _cubit => _shippingCubit;

  GenericCubit<List<AddressModel>> get _addressesCubit =>
      _addressBook.addressesCubit;

  GenericCubit<CartData> get _cartCubit => _cart.cartCubit;

  CheckoutShippingData get _data => _shippingCubit.state.data;

  CartModel get _cartModel => _cart.cart;

  List<AddressModel> get _addresses => _addressBook.addresses;

  Future<void> _init() async {
    await _addressBook.load();

    final AddressModel? preselected = _addressBook.defaultAddress;

    if (preselected == null) {
      _shippingCubit.onUpdateData(
        _data.copyWith(status: CheckoutShippingStatus.success),
      );

      return;
    }

    await _selectAddress(preselected);
  }

  void _dispose() {
    _shippingCubit.close();
  }

  void _back() {
    _nav.pop();
  }

  void _toggleShowAllAddresses() {
    _shippingCubit.onUpdateData(
      _data.copyWith(showAllAddresses: !_data.showAllAddresses),
    );
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
    final AddressModel? before = _selectedAddress;

    await _nav.pushNamedAndReturn(
      RouteNames.addressForm,
      extra: address == null ? null : AddressFormArgs(address: address),
    );

    final AddressModel? after = _selectedAddress ?? _addressBook.defaultAddress;

    if (after == null) return;

    // Equality ignores the default flag, so saving an unrelated address — or
    // cancelling out of the form — costs nothing.
    if (before == after) return;

    await _selectAddress(after);
  }

  Future<void> _deleteAddress(AddressModel address) async {
    await _addressBook.remove(address.id);

    if (_data.selectedAddressId != address.id) return;

    // The quote belonged to the address that just went away, so it has to be
    // dropped rather than left on screen against a different address.
    _shippingCubit.onUpdateData(
      _data.copyWith(
        selectedAddressId: '',
        methods: const [],
        clearSelectedMethod: true,
      ),
    );

    final AddressModel? next = _addressBook.defaultAddress;

    if (next != null) await _selectAddress(next);
  }

  /// Re-applies even when the same card is tapped again: the address may have
  /// just been edited, and the quote has to follow it.
  Future<void> _selectAddress(AddressModel address) async {
    _shippingCubit.onUpdateData(
      _data.copyWith(
        selectedAddressId: address.id,
        isApplyingAddress: true,
        status: CheckoutShippingStatus.loading,
        methods: const [],
        clearSelectedMethod: true,
        clearErrorMessage: true,
      ),
    );

    final String cartId = await _cart.ensureCartId();

    if (cartId.isEmpty) {
      _fail(_cart.data.errorMessage);

      return;
    }

    try {
      await _graphql.mutate(
        GraphQLDocuments.setShippingAddressesOnCart,
        variables: SetShippingAddressRequest(
          cartId: cartId,
          address: address,
        ).toVariables(),
      );

      // The design has no separate billing step, so the shipping address is
      // replayed as the billing one — `placeOrder` rejects a cart without it.
      await _graphql.mutate(
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

  /// `placeOrder` refuses a guest cart with no email
  /// (`code: "GUEST_EMAIL_MISSING"`), and nothing in the checkout design
  /// collects one — so it comes from the account: the address typed at login,
  /// or the one saved in the profile. Both land on `PrefKeys.email`.
  ///
  /// Its own failures are swallowed rather than failing the address step: a
  /// missing or malformed account email is not a reason to hide the address
  /// list, so [_proceed] reports it at the point the user tries to move on.
  Future<void> _setGuestEmail(String cartId) async {
    final String email = _prefs.getString(PrefKeys.email).trim();

    if (email.isEmpty) {
      _shippingCubit.onUpdateData(
        _data.copyWith(isEmailReady: false, clearEmailError: true),
      );

      return;
    }

    try {
      await _graphql.mutate(
        GraphQLDocuments.setGuestEmailOnCart,
        variables: {'cartId': cartId, 'email': email},
      );

      _shippingCubit.onUpdateData(
        _data.copyWith(isEmailReady: true, clearEmailError: true),
      );
    } catch (error) {
      // Magento validates the format, so a bad stored address lands here.
      _shippingCubit.onUpdateData(
        _data.copyWith(
          isEmailReady: false,
          emailErrorMessage: errorMessageFrom(error),
        ),
      );
    }
  }

  Future<void> _loadShippingMethods(String cartId) async {
    final Map<String, dynamic> response = await _graphql.query(
      GraphQLDocuments.getCartShippingMethods,
      variables: {'cartId': cartId},
    );

    final List<ShippingMethodModel> methods = _methodsFrom(response);

    // Magento may already hold a method from an earlier visit; honour it so
    // the radio matches the cart, otherwise take the first quote.
    final ShippingMethodModel? current = _selectedMethodFrom(response);

    final String selectedKey = current != null && !current.isEmpty
        ? current.key
        : (methods.isEmpty ? '' : methods.first.key);

    _shippingCubit.onUpdateData(
      _data.copyWith(
        status: CheckoutShippingStatus.success,
        isApplyingAddress: false,
        methods: methods,
        selectedMethodKey: selectedKey,
        clearSelectedMethod: selectedKey.isEmpty,
        clearErrorMessage: true,
      ),
    );

    if (selectedKey.isEmpty) return;

    // The totals need the carrier's price, which only lands on the cart once
    // the method is actually set.
    await _applyMethod(_methodByKey(selectedKey), silent: true);
  }

  Future<void> _selectMethod(ShippingMethodModel? method) async {
    if (method == null || method.isEmpty) return;
    if (method.key == _data.selectedMethodKey && _cartModel.shippingCost > 0) {
      return;
    }

    _shippingCubit.onUpdateData(
      _data.copyWith(selectedMethodKey: method.key, clearErrorMessage: true),
    );

    await _applyMethod(method);
  }

  /// [silent] keeps the automatic first-quote apply from flashing an error
  /// toast on a screen the user has not touched yet.
  Future<void> _applyMethod(
    ShippingMethodModel? method, {
    bool silent = false,
  }) async {
    if (method == null || method.isEmpty) return;

    _shippingCubit.onUpdateData(_data.copyWith(isSettingMethod: true));

    try {
      await _graphql.mutate(
        GraphQLDocuments.setShippingMethodsOnCart,
        variables: SetShippingMethodRequest(
          cartId: _cart.cartId,
          carrierCode: method.carrierCode,
          methodCode: method.methodCode,
        ).toVariables(),
      );

      // Re-read rather than trust the mutation's slim selection: the grand
      // total now includes delivery and the totals card reads it off the cart.
      await _cart.refresh();
    } catch (error) {
      if (!silent) _alert.showError(errorMessageFrom(error));
    } finally {
      _shippingCubit.onUpdateData(_data.copyWith(isSettingMethod: false));
    }
  }

  Future<void> _retry() async {
    final AddressModel? address = _selectedAddress;

    if (address == null) return _init();

    await _selectAddress(address);
  }

  void _proceed() {
    if (!_data.hasAddress) {
      _alert.showError(LocaleKeys.checkoutSelectAddress.tr());

      return;
    }

    if (!_data.hasMethod) {
      _alert.showError(LocaleKeys.checkoutSelectShippingMethod.tr());

      return;
    }

    // Caught here rather than at `placeOrder`, which is two screens and a
    // payment choice later.
    if (!_data.isEmailReady) {
      _alert.showError(
        _data.emailErrorMessage.isNotEmpty
            ? _data.emailErrorMessage
            : LocaleKeys.checkoutEmailMissing.tr(),
      );

      return;
    }

    _nav.pushNamed(RouteNames.checkoutPayment);
  }

  AddressModel? get _selectedAddress {
    for (final AddressModel address in _addresses) {
      if (address.id == _data.selectedAddressId) return address;
    }

    return null;
  }

  /// Collapsed the list shows the chosen card alone; expanded it shows the
  /// whole book with the chosen one first.
  List<AddressModel> get _visibleAddresses {
    final AddressModel? selected = _selectedAddress;

    if (_data.showAllAddresses) {
      if (selected == null) return _addresses;

      return <AddressModel>[
        selected,
        ..._addresses.where((AddressModel item) => item.id != selected.id),
      ];
    }

    if (selected != null) return <AddressModel>[selected];

    return _addresses.isEmpty ? const [] : <AddressModel>[_addresses.first];
  }

  ShippingMethodModel? _methodByKey(String key) {
    for (final ShippingMethodModel method in _data.methods) {
      if (method.key == key) return method;
    }

    return null;
  }

  List<ShippingMethodModel> _methodsFrom(Map<String, dynamic> response) {
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
    _shippingCubit.onUpdateData(
      _data.copyWith(
        status: CheckoutShippingStatus.error,
        isApplyingAddress: false,
        isSettingMethod: false,
        errorMessage: message,
      ),
    );
  }
}
