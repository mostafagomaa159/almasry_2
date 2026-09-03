part of '../checkout_payment_imports.dart';

typedef ListPaymentMethods = List<PaymentMethodModel>;

class CheckoutPaymentViewModel {
  final _graphqlService = sl<GraphQLService>();
  final _alertService = sl<AlertService>();
  final _cartService = sl<CartService>();
  final _checkoutFlowService = sl<CheckoutFlowService>();

  final GenericCubit<ListPaymentMethods> _methodsCubit =
      GenericCubit<ListPaymentMethods>([]);

  final GenericCubit<bool> _loadingCubit = GenericCubit<bool>(true);

  final GenericCubit<String> _selectedCodeCubit = GenericCubit<String>('');

  final GenericCubit<String> _selectedOptionCubit = GenericCubit<String>('');

  final GenericCubit<String> _expandedCodeCubit = GenericCubit<String>('');

  final GenericCubit<bool> _submittingCubit = GenericCubit<bool>(false);

  GenericCubit<CartModel> get _cartCubit => _cartService.cartCubit;

  CartModel _cart() => _cartService.cart;

  String _errorMessage = '';

  Future<void> _init() async {
    await _cartService.loadCart();

    await _loadMethods();
  }

  ListPaymentMethods _methods() => _methodsCubit.state.data;

  PaymentMethodModel? _selectedMethod() {
    for (final PaymentMethodModel method in _methods()) {
      if (method.code == _selectedCodeCubit.state.data) return method;
    }

    return null;
  }

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

      _methodsCubit.onUpdateData(const []);
    } finally {
      _loadingCubit.onUpdateData(false);
    }
  }

  String _initialCode(ListPaymentMethods methods) {
    final String onCart = _cart().selectedPaymentMethod.code;

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

    final String onCart = _cart().selectedPaymentMethod.selectedOption;

    for (final PaymentOptionModel option in method.options) {
      if (option.code == onCart) return onCart;
    }

    return method.options.first.code;
  }

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

      await _cartService.loadCart();

      _checkoutFlowService.next();
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
}
