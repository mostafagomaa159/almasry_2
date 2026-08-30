part of '../checkout_review_imports.dart';

/// Step three: show back everything the cart now holds, then place the order.
///
/// This screen makes no read of its own — the address, the carrier and the
/// payment method were all written onto the cart by the earlier steps, and
/// `CartService` re-read it after each one.
class CheckoutReviewViewModel {
  final GraphQLService _graphqlService = sl<GraphQLService>();
  final NavigationService _navService = sl<NavigationService>();
  final AlertService _alertService = sl<AlertService>();
  final CartService _cartService = sl<CartService>();

  /// The design opens with all three sections expanded and lets each collapse
  /// on its own, so they are three cubits rather than one selected index.
  final GenericCubit<bool> _productsExpandedCubit = GenericCubit<bool>(true);
  final GenericCubit<bool> _orderExpandedCubit = GenericCubit<bool>(true);
  final GenericCubit<bool> _billExpandedCubit = GenericCubit<bool>(true);

  final GenericCubit<bool> _placingOrderCubit = GenericCubit<bool>(false);

  late final GenericCubit<CartData> _cartCubit = _cartService.cartCubit;

  CartModel _cartModel() => _cartService.cart;

  void _init() {}

  void _dispose() {
    _productsExpandedCubit.close();
    _orderExpandedCubit.close();
    _billExpandedCubit.close();
    _placingOrderCubit.close();
  }

  void _back() {
    _navService.pop();
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
    final CartModel cart = _cartModel();

    return cart.shippingAddress?.summaryLine ?? '';
  }

  String _shippingCompanyLine() {
    final ShippingMethodModel? method = _cartModel().selectedShippingMethod;

    return method == null ? '' : method.displayTitle;
  }

  String _paymentMethodLine() =>
      _cartModel().selectedPaymentMethod.displayTitle;

  /// `placeOrder` answers 200 with an `errors` list when it refuses, so a
  /// successful call is not a successful order — [PlaceOrderResponse.isSuccess]
  /// is what decides.
  Future<void> _placeOrder() async {
    if (_placingOrderCubit.state.data) return;

    _placingOrderCubit.onUpdateData(true);

    // Read before the cart is cleared — the confirmation screen prints it.
    final double grandTotal = _cartModel().grandTotal;

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

      await _cartService.clearAfterOrder();

      // `goNamed`, not push: the quote is gone, so the three checkout steps
      // behind this must not stay on the stack to be walked back into.
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
