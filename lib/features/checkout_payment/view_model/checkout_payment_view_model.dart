part of '../checkout_payment_imports.dart';

/// Step two of the checkout: pick a payment method.
///
/// The choice is only pushed to Magento when the user moves on, not on every
/// tap — the review screen reads `cart.selected_payment_method`, so the
/// mutation has to land before navigating but need not land before that.
class CheckoutPaymentViewModel {
  final GraphQLService _graphql = sl<GraphQLService>();
  final NavigationService _nav = sl<NavigationService>();
  final AlertService _alert = sl<AlertService>();
  final CartService _cart = sl<CartService>();

  final GenericCubit<CheckoutPaymentData> _paymentCubit =
      GenericCubit<CheckoutPaymentData>(const CheckoutPaymentData());

  GenericCubit<CheckoutPaymentData> get _cubit => _paymentCubit;

  GenericCubit<CartData> get _cartCubit => _cart.cartCubit;

  CheckoutPaymentData get _data => _paymentCubit.state.data;

  Future<void> _init() => _loadMethods();

  void _dispose() {
    _paymentCubit.close();
  }

  void _back() {
    _nav.pop();
  }

  Future<void> _loadMethods() async {
    _paymentCubit.onUpdateData(
      _data.copyWith(
        status: CheckoutPaymentStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final Map<String, dynamic> response = await _graphql.query(
        GraphQLDocuments.getAvailablePaymentMethods,
        variables: {'cartId': _cart.cartId},
      );

      final List<PaymentMethodModel> methods =
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

      _paymentCubit.onUpdateData(
        _data
            .copyWith(status: CheckoutPaymentStatus.success, methods: methods)
            .copyWith(
              selectedCode: _initialCode(methods),
              selectedOptionCode: _initialOptionCode(methods),
            ),
      );
    } catch (error) {
      _paymentCubit.onUpdateData(
        _data.copyWith(
          status: CheckoutPaymentStatus.error,
          errorMessage: errorMessageFrom(error),
        ),
      );
    }
  }

  /// Honours whatever the cart already holds — coming back from the review
  /// step should not silently reset the choice — and otherwise preselects the
  /// first method, which is how the design opens.
  String _initialCode(List<PaymentMethodModel> methods) {
    final String onCart = _cart.cart.selectedPaymentMethod.code;

    for (final PaymentMethodModel method in methods) {
      if (method.code == onCart) return onCart;
    }

    return methods.isEmpty ? '' : methods.first.code;
  }

  String _initialOptionCode(List<PaymentMethodModel> methods) {
    if (methods.isEmpty) return '';

    final String code = _initialCode(methods);

    final PaymentMethodModel method = methods.firstWhere(
      (PaymentMethodModel item) => item.code == code,
      orElse: () => methods.first,
    );

    if (!method.hasOptions) return '';

    final String onCart = _cart.cart.selectedPaymentMethod.selectedOption;

    for (final PaymentOptionModel option in method.options) {
      if (option.code == onCart) return onCart;
    }

    return method.options.first.code;
  }

  /// Picking a method opens it if it has providers, and preselects the first
  /// one so the row is a complete choice on a single tap.
  void _selectMethod(PaymentMethodModel method) {
    _paymentCubit.onUpdateData(
      _data.copyWith(
        selectedCode: method.code,
        selectedOptionCode: method.hasOptions
            ? method.options.first.code
            : null,
        clearSelectedOption: !method.hasOptions,
        expandedCode: method.hasOptions ? method.code : null,
        clearExpanded: !method.hasOptions,
      ),
    );
  }

  void _selectOption(PaymentMethodModel method, PaymentOptionModel option) {
    _paymentCubit.onUpdateData(
      _data.copyWith(
        selectedCode: method.code,
        selectedOptionCode: option.code,
        expandedCode: method.code,
      ),
    );
  }

  void _toggleExpanded(PaymentMethodModel method) {
    final bool isOpen = _data.expandedCode == method.code;

    _paymentCubit.onUpdateData(
      _data.copyWith(
        expandedCode: isOpen ? null : method.code,
        clearExpanded: isOpen,
      ),
    );
  }

  Future<void> _proceed() async {
    if (_data.isSubmitting) return;

    if (!_data.canProceed) {
      _alert.showError(LocaleKeys.checkoutSelectPaymentMethod.tr());

      return;
    }

    _paymentCubit.onUpdateData(
      _data.copyWith(isSubmitting: true, clearErrorMessage: true),
    );

    try {
      await _graphql.mutate(
        GraphQLDocuments.setPaymentMethodOnCart,
        variables: SetPaymentMethodRequest(
          cartId: _cart.cartId,
          code: _data.selectedCode,
          selectedOption: _data.selectedOptionCode,
        ).toVariables(),
      );

      // The review screen prints the method off the cart, so it has to see the
      // one that was just set.
      await _cart.refresh();

      _nav.pushNamed(RouteNames.checkoutReview);
    } catch (error) {
      _alert.showError(errorMessageFrom(error));
    } finally {
      _paymentCubit.onUpdateData(_data.copyWith(isSubmitting: false));
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
