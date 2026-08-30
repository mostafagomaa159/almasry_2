part of '../checkout_payment_imports.dart';

typedef ListPaymentMethods = List<PaymentMethodModel>;

class CheckoutPaymentViewModel {
  final GraphQLService _graphqlService = sl<GraphQLService>();
  final NavigationService _navService = sl<NavigationService>();
  final AlertService _alertService = sl<AlertService>();
  final CartService _cartService = sl<CartService>();

  final GenericCubit<ListPaymentMethods> _methodsCubit =
      GenericCubit<ListPaymentMethods>([]);

  final GenericCubit<bool> _loadingCubit = GenericCubit<bool>(true);

  /// The Magento payment method `code`.
  final GenericCubit<String> _selectedCodeCubit = GenericCubit<String>('');

  /// The sub-option code, for the methods that carry a list of providers.
  /// Empty for the ones that do not.
  final GenericCubit<String> _selectedOptionCubit = GenericCubit<String>('');

  /// Which expandable row is open. Independent of the selection: the design
  /// lets a row be opened to look at its providers without choosing it.
  final GenericCubit<String> _expandedCodeCubit = GenericCubit<String>('');

  final GenericCubit<bool> _submittingCubit = GenericCubit<bool>(false);

  late final GenericCubit<CartData> _cartCubit = _cartService.cartCubit;

  String _errorMessage = '';

  Future<void> _init() => _loadMethods();

  void _dispose() {
    _methodsCubit.close();
    _loadingCubit.close();
    _selectedCodeCubit.close();
    _selectedOptionCubit.close();
    _expandedCodeCubit.close();
    _submittingCubit.close();
  }

  void _back() {
    _navService.pop();
  }

  ListPaymentMethods _methods() => _methodsCubit.state.data;

  PaymentMethodModel? _selectedMethod() {
    for (final PaymentMethodModel method in _methods()) {
      if (method.code == _selectedCodeCubit.state.data) return method;
    }

    return null;
  }

  /// A method with providers is not a complete choice until one is picked, so
  /// the button stays inert until then.
  bool _canProceed() {
    final PaymentMethodModel? method = _selectedMethod();

    if (method == null) return false;

    return !method.hasOptions ||
        _selectedOptionCubit.state.data.trim().isNotEmpty;
  }

  Future<void> _loadMethods() async {
    _loadingCubit.onUpdateData(true);

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

      _errorMessage = '';

      _methodsCubit.onUpdateData(methods);
      _selectedCodeCubit.onUpdateData(_initialCode(methods));
      _selectedOptionCubit.onUpdateData(_initialOptionCode(methods));
    } catch (error) {
      _errorMessage = errorMessageFrom(error);

      /// Empty list + a message is what the body reads as "error".
      _methodsCubit.onUpdateData(const []);
    } finally {
      _loadingCubit.onUpdateData(false);
    }
  }

  /// Honours whatever the cart already holds — coming back from the review
  /// step should not silently reset the choice — and otherwise preselects the
  /// first method, which is how the design opens.
  String _initialCode(ListPaymentMethods methods) {
    final String onCart = _cartService.cart.selectedPaymentMethod.code;

    for (final PaymentMethodModel method in methods) {
      if (method.code == onCart) return onCart;
    }

    return methods.isEmpty ? '' : methods.first.code;
  }

  String _initialOptionCode(ListPaymentMethods methods) {
    if (methods.isEmpty) return '';

    final String code = _initialCode(methods);

    final PaymentMethodModel method = methods.firstWhere(
      (PaymentMethodModel item) => item.code == code,
      orElse: () => methods.first,
    );

    if (!method.hasOptions) return '';

    final String onCart =
        _cartService.cart.selectedPaymentMethod.selectedOption;

    for (final PaymentOptionModel option in method.options) {
      if (option.code == onCart) return onCart;
    }

    return method.options.first.code;
  }

  /// Picking a method opens it if it has providers, and preselects the first
  /// one so the row is a complete choice on a single tap.
  void _selectMethod(PaymentMethodModel method) {
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

  Future<void> _proceed() async {
    if (_submittingCubit.state.data) return;

    if (!_canProceed()) {
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

      // The review screen prints the method off the cart, so it has to see the
      // one that was just set.
      await _cartService.refresh();

      _navService.pushNamed(RouteNames.checkoutReview);
    } catch (error) {
      _alertService.showError(errorMessageFrom(error));
    } finally {
      _submittingCubit.onUpdateData(false);
    }
  }

  /// The API gives a code and a title but no copy, and the design carries a
  /// line under each row — so the wording is chosen here.
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

  /// Only used when a method has no provider logo of its own.
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
}
