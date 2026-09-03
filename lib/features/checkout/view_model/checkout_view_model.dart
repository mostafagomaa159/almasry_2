part of '../checkout_imports.dart';

typedef ListAddresses = List<AddressModel>;
typedef ListShippingMethods = List<ShippingMethodModel>;
typedef ListPaymentMethods = List<PaymentMethodModel>;

class CheckoutViewModel {
  final _graphqlService = sl<GraphQLService>();
  final _navService = sl<NavigationService>();
  final _alertService = sl<AlertService>();
  final _cartService = sl<CartService>();
  final _addressBookService = sl<AddressBookService>();
  final _checkoutFlowService = sl<CheckoutFlowService>();
  final _prefsService = sl<SharedPrefsServices>();

  final PageController _pageController = PageController();

  final GenericCubit<String> _selectedAddressIdCubit = GenericCubit<String>('');

  final GenericCubit<bool> _showAllAddressesCubit = GenericCubit<bool>(false);

  final GenericCubit<ListShippingMethods> _shippingMethodsCubit =
      GenericCubit<ListShippingMethods>([]);

  final GenericCubit<String> _selectedMethodKeyCubit = GenericCubit<String>('');

  final GenericCubit<bool> _applyingAddressCubit = GenericCubit<bool>(false);

  final GenericCubit<bool> _settingMethodCubit = GenericCubit<bool>(false);

  final GenericCubit<ListPaymentMethods> _paymentMethodsCubit =
      GenericCubit<ListPaymentMethods>([]);

  final GenericCubit<bool> _paymentLoadingCubit = GenericCubit<bool>(true);

  final GenericCubit<String> _selectedCodeCubit = GenericCubit<String>('');

  final GenericCubit<String> _selectedOptionCubit = GenericCubit<String>('');

  final GenericCubit<String> _expandedCodeCubit = GenericCubit<String>('');

  final GenericCubit<bool> _submittingCubit = GenericCubit<bool>(false);

  final GenericCubit<bool> _productsExpandedCubit = GenericCubit<bool>(true);

  final GenericCubit<bool> _orderExpandedCubit = GenericCubit<bool>(true);

  final GenericCubit<bool> _billExpandedCubit = GenericCubit<bool>(true);

  final GenericCubit<bool> _placingOrderCubit = GenericCubit<bool>(false);

  late final GenericCubit<int> _stepCubit = _checkoutFlowService.stepCubit;

  late final GenericCubit<CartModel> _cartCubit = _cartService.cartCubit;

  late final GenericCubit<ListAddresses> _addressesCubit =
      _addressBookService.addressesCubit;

  String _shippingErrorMessage = '';

  String _paymentErrorMessage = '';

  CartModel _cart() => _cartService.cart;

  void _init() {
    _checkoutFlowService.attach(_pageController);

    _loadStep(CheckoutFlowService.cartStep);
  }

  void _dispose() {
    _checkoutFlowService.detach(_pageController);
    _pageController.dispose();
  }

  Future<void> _loadStep(int step) => switch (step) {
    CheckoutFlowService.shippingStep => _loadShipping(),
    CheckoutFlowService.paymentStep => _loadPayment(),
    _ => _cartService.loadCart(),
  };

  void _onPageChanged(int index) => _checkoutFlowService.syncStep(index);

  void _forward() {
    _loadStep(_checkoutFlowService.step + 1);

    _checkoutFlowService.next();
  }

  void _back() {
    if (_checkoutFlowService.step == CheckoutFlowService.cartStep) return;

    _loadStep(_checkoutFlowService.step - 1);

    _checkoutFlowService.previous();
  }

  String _title(int step) {
    return step == CheckoutFlowService.cartStep
        ? LocaleKeys.cart.tr()
        : LocaleKeys.checkoutTitle.tr();
  }

  CheckoutStep _stepperStep(int step) => switch (step) {
    CheckoutFlowService.paymentStep => CheckoutStep.payment,
    CheckoutFlowService.reviewStep => CheckoutStep.review,
    _ => CheckoutStep.address,
  };

  Future<void> _refreshCart() => _cartService.loadCart();

  Future<void> _incrementQuantity(CartItemModel item) {
    return _cartService.updateQuantity(item: item, quantity: item.quantity + 1);
  }

  Future<void> _decrementQuantity(CartItemModel item) {
    return _cartService.updateQuantity(item: item, quantity: item.quantity - 1);
  }

  void _confirmRemoveItem(CartItemModel item) {
    _alertService.showConfirmation(
      title: LocaleKeys.cartRemoveConfirm.tr(),
      confirmTitle: LocaleKeys.confirm.tr(),
      cancelTitle: LocaleKeys.cancel.tr(),
      onConfirm: () => _removeItem(item),
    );
  }

  Future<void> _removeItem(CartItemModel item) async {
    final bool removed = await _cartService.removeItem(item);

    if (removed) _alertService.showSuccess(LocaleKeys.cartItemRemoved.tr());
  }

  void _navToCheckout() {
    if (_cart().isEmpty) return;

    _forward();
  }

  ListAddresses _addresses() => _addressBookService.addresses;

  ListShippingMethods _shippingMethods() => _shippingMethodsCubit.state.data;

  bool _hasAddress() => _selectedAddressIdCubit.state.data.trim().isNotEmpty;

  bool _hasMethod() => _selectedMethodKeyCubit.state.data.trim().isNotEmpty;

  Future<void> _loadShipping() async {
    _shippingErrorMessage = '';

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
    _shippingMethodsCubit.onUpdateData(const []);

    final AddressModel? next = _addressBookService.defaultAddress;

    if (next != null) await _selectAddress(next);
  }

  Future<void> _selectAddress(AddressModel address) async {
    _shippingErrorMessage = '';

    _checkoutFlowService.selectedAddressId = address.id;

    _selectedAddressIdCubit.onUpdateData(address.id);
    _selectedMethodKeyCubit.onUpdateData('');
    _applyingAddressCubit.onUpdateData(true);
    _shippingMethodsCubit.onUpdateData(const []);

    final String id = await _cartService.ensureCartId();

    if (id.isEmpty) {
      _failShipping(LocaleKeys.somethingWentWrong.tr());

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
      _failShipping(errorMessageFrom(error));
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

    final ListShippingMethods methods = _shippingMethodsFrom(response);

    final ShippingMethodModel? current = _selectedShippingMethodFrom(response);

    final String selectedKey = current != null && !current.isEmpty
        ? current.key
        : (methods.isEmpty ? '' : methods.first.key);

    _shippingErrorMessage = '';

    _applyingAddressCubit.onUpdateData(false);
    _selectedMethodKeyCubit.onUpdateData(selectedKey);
    _shippingMethodsCubit.onUpdateData(methods);

    if (selectedKey.isEmpty) return;

    await _applyShippingMethod(_shippingMethodByKey(selectedKey), silent: true);
  }

  Future<void> _selectShippingMethod(ShippingMethodModel? method) async {
    if (method == null || method.isEmpty) return;
    if (method.key == _selectedMethodKeyCubit.state.data &&
        _cart().shippingCost > 0) {
      return;
    }

    _shippingErrorMessage = '';

    _selectedMethodKeyCubit.onUpdateData(method.key);

    await _applyShippingMethod(method);
  }

  Future<void> _applyShippingMethod(
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

  Future<void> _retryShipping() async {
    final AddressModel? address = _selectedAddress();

    if (address == null) return _loadShipping();

    await _selectAddress(address);
  }

  void _proceedFromShipping() {
    if (!_hasAddress()) {
      _alertService.showError(LocaleKeys.checkoutSelectAddress.tr());

      return;
    }

    if (!_hasMethod()) {
      _alertService.showError(LocaleKeys.checkoutSelectShippingMethod.tr());

      return;
    }

    _forward();
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

  ShippingMethodModel? _shippingMethodByKey(String key) {
    for (final ShippingMethodModel method in _shippingMethods()) {
      if (method.key == key) return method;
    }

    return null;
  }

  ListShippingMethods _shippingMethodsFrom(Map<String, dynamic> response) {
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

  ShippingMethodModel? _selectedShippingMethodFrom(
    Map<String, dynamic> response,
  ) {
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

  void _failShipping(String message) {
    _shippingErrorMessage = message;

    _applyingAddressCubit.onUpdateData(false);
    _settingMethodCubit.onUpdateData(false);
    _shippingMethodsCubit.onUpdateData(const []);
  }

  Future<void> _loadPayment() async {
    await _cartService.loadCart();

    await _loadPaymentMethods();
  }

  ListPaymentMethods _paymentMethods() => _paymentMethodsCubit.state.data;

  PaymentMethodModel? _selectedPaymentMethod() {
    for (final PaymentMethodModel method in _paymentMethods()) {
      if (method.code == _selectedCodeCubit.state.data) return method;
    }

    return null;
  }

  bool _canProceedFromPayment() {
    final PaymentMethodModel? method = _selectedPaymentMethod();

    if (method == null) return false;

    return !method.hasOptions ||
        _selectedOptionCubit.state.data.trim().isNotEmpty;
  }

  Future<void> _loadPaymentMethods() async {
    _paymentLoadingCubit.onUpdateData(true);

    try {
      final Map<String, dynamic> response = await _graphqlService.query(
        GraphQLDocuments.getAvailablePaymentMethods,
        variables: {'cartId': _cartService.cartId},
      );

      final ListPaymentMethods methods =
          ((response['cart']
                          as Map<
                            String,
                            dynamic
                          >?)?['available_payment_methods']
                      as List<dynamic>? ??
                  const [])
              .whereType<Map<String, dynamic>>()
              .map(PaymentMethodModel.fromJson)
              .where((PaymentMethodModel method) => method.code.isNotEmpty)
              .toList();

      _paymentErrorMessage = '';

      _paymentMethodsCubit.onUpdateData(methods);
      _selectedCodeCubit.onUpdateData(_initialPaymentCode(methods));
      _selectedOptionCubit.onUpdateData(_initialPaymentOptionCode(methods));
    } catch (error) {
      _paymentErrorMessage = errorMessageFrom(error);

      _paymentMethodsCubit.onUpdateData(const []);
    } finally {
      _paymentLoadingCubit.onUpdateData(false);
    }
  }

  String _initialPaymentCode(ListPaymentMethods methods) {
    final String onCart = _cart().selectedPaymentMethod.code;

    for (final PaymentMethodModel method in methods) {
      if (method.code == onCart) return onCart;
    }

    return methods.isEmpty ? '' : methods.first.code;
  }

  String _initialPaymentOptionCode(ListPaymentMethods methods) {
    if (methods.isEmpty) return '';

    final String code = _initialPaymentCode(methods);

    final PaymentMethodModel method = methods.firstWhere(
      (PaymentMethodModel item) => item.code == code,
      orElse: () => methods.first,
    );

    if (!method.hasOptions) return '';

    final String onCart = _cart().selectedPaymentMethod.selectedOption;

    for (final PaymentOptionModel option in method.options) {
      if (option.code == onCart) return onCart;
    }

    return method.options.first.code;
  }

  void _selectPaymentMethod(PaymentMethodModel method) {
    _selectedCodeCubit.onUpdateData(method.code);

    _selectedOptionCubit.onUpdateData(
      method.hasOptions ? method.options.first.code : '',
    );

    _expandedCodeCubit.onUpdateData(method.hasOptions ? method.code : '');
  }

  void _selectOption(PaymentMethodModel method, PaymentOptionModel option) {
    _selectedCodeCubit.onUpdateData(method.code);
    _selectedOptionCubit.onUpdateData(option.code);
    _expandedCodeCubit.onUpdateData(method.code);
  }

  void _toggleExpanded(PaymentMethodModel method) {
    final bool isOpen = _expandedCodeCubit.state.data == method.code;

    _expandedCodeCubit.onUpdateData(isOpen ? '' : method.code);
  }

  Future<void> _proceedFromPayment() async {
    if (_submittingCubit.state.data) return;

    if (!_canProceedFromPayment()) {
      _alertService.showError(LocaleKeys.checkoutSelectPaymentMethod.tr());

      return;
    }

    _submittingCubit.onUpdateData(true);

    try {
      await _graphqlService.mutate(
        GraphQLDocuments.setPaymentMethodOnCart,
        variables: SetPaymentMethodRequest(
          cartId: _cartService.cartId,
          code: _selectedCodeCubit.state.data,
          selectedOption: _selectedOptionCubit.state.data,
        ).toVariables(),
      );

      await _cartService.loadCart();

      _forward();
    } catch (error) {
      _alertService.showError(errorMessageFrom(error));
    } finally {
      _submittingCubit.onUpdateData(false);
    }
  }

  String _hintFor(PaymentMethodModel method) {
    final String code = method.code.toLowerCase();

    final bool isCashOnDelivery =
        code.contains('cashondelivery') ||
        code.contains('cash_on_delivery') ||
        code == 'cod' ||
        code.contains('checkmo');

    return isCashOnDelivery
        ? LocaleKeys.checkoutPaymentCodHint.tr()
        : LocaleKeys.checkoutPaymentLinkHint.tr();
  }

  IconData _iconFor(PaymentMethodModel method) {
    final String code = method.code.toLowerCase();

    if (code.contains('cash') || code.contains('cod')) {
      return Icons.payments_outlined;
    }

    if (code.contains('install')) return Icons.calendar_month_outlined;

    if (code.contains('card') || code.contains('bank')) {
      return Icons.credit_card;
    }

    return Icons.account_balance_wallet_outlined;
  }

  void _toggleProducts() {
    _productsExpandedCubit.onUpdateData(!_productsExpandedCubit.state.data);
  }

  void _toggleOrderDetails() {
    _orderExpandedCubit.onUpdateData(!_orderExpandedCubit.state.data);
  }

  void _toggleBill() {
    _billExpandedCubit.onUpdateData(!_billExpandedCubit.state.data);
  }

  String _shippingAddressLine() {
    final CartModel cart = _cart();

    return cart.shippingAddress?.summaryLine ?? '';
  }

  String _shippingCompanyLine() {
    final ShippingMethodModel? method = _cart().selectedShippingMethod;

    return method == null ? '' : method.displayTitle;
  }

  String _paymentMethodLine() => _cart().selectedPaymentMethod.displayTitle;

  Future<void> _placeOrder() async {
    if (_placingOrderCubit.state.data) return;

    _placingOrderCubit.onUpdateData(true);

    final double grandTotal = _cart().grandTotal;

    try {
      final Map<String, dynamic> json = await _graphqlService.mutate(
        GraphQLDocuments.placeOrder,
        variables: {'cartId': _cartService.cartId},
      );

      final PlaceOrderResponse response = PlaceOrderResponse.fromJson(json);

      if (!response.isSuccess) {
        _alertService.showError(
          response.errors.isEmpty
              ? LocaleKeys.somethingWentWrong.tr()
              : response.errors.first,
        );

        return;
      }

      await _cartService.clearCart();

      _checkoutFlowService.reset();

      _navService.goNamed(
        RouteNames.orderConfirmed,
        extra: OrderConfirmedArgs(
          orderNumber: response.orderNumber,
          grandTotal: grandTotal,
        ),
      );
    } catch (error) {
      _alertService.showError(errorMessageFrom(error));
    } finally {
      _placingOrderCubit.onUpdateData(false);
    }
  }
}
