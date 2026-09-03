part of '../checkout_review_imports.dart';

class CheckoutReviewViewModel {
  final _graphqlService = sl<GraphQLService>();
  final _navService = sl<NavigationService>();
  final _alertService = sl<AlertService>();
  final _cartService = sl<CartService>();
  final _checkoutFlowService = sl<CheckoutFlowService>();

  final GenericCubit<bool> _productsExpandedCubit = GenericCubit<bool>(true);
  final GenericCubit<bool> _orderExpandedCubit = GenericCubit<bool>(true);
  final GenericCubit<bool> _billExpandedCubit = GenericCubit<bool>(true);

  final GenericCubit<bool> _placingOrderCubit = GenericCubit<bool>(false);

  GenericCubit<CartModel> get _cartCubit => _cartService.cartCubit;

  CartModel _cart() => _cartService.cart;

  Future<void> _init() => _cartService.loadCart();

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
