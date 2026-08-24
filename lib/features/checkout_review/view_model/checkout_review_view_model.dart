part of '../checkout_review_imports.dart';

/// Step three: show back everything the cart now holds, then place the order.
///
/// This screen makes no read of its own — the address, the carrier and the
/// payment method were all written onto the cart by the earlier steps, and
/// `CartService` re-read it after each one.
class CheckoutReviewViewModel {
  final GraphQLService _graphql = sl<GraphQLService>();
  final NavigationService _nav = sl<NavigationService>();
  final AlertService _alert = sl<AlertService>();
  final CartService _cart = sl<CartService>();

  final GenericCubit<CheckoutReviewData> _reviewCubit =
      GenericCubit<CheckoutReviewData>(const CheckoutReviewData());

  GenericCubit<CheckoutReviewData> get _cubit => _reviewCubit;

  GenericCubit<CartData> get _cartCubit => _cart.cartCubit;

  CheckoutReviewData get _data => _reviewCubit.state.data;

  CartModel get _cartModel => _cart.cart;

  void _init() {}

  void _dispose() {
    _reviewCubit.close();
  }

  void _back() {
    _nav.pop();
  }

  void _toggleProducts() {
    _reviewCubit.onUpdateData(
      _data.copyWith(isProductsExpanded: !_data.isProductsExpanded),
    );
  }

  void _toggleOrderDetails() {
    _reviewCubit.onUpdateData(
      _data.copyWith(isOrderDetailsExpanded: !_data.isOrderDetailsExpanded),
    );
  }

  void _toggleBill() {
    _reviewCubit.onUpdateData(
      _data.copyWith(isBillExpanded: !_data.isBillExpanded),
    );
  }

  String _shippingAddressLine() {
    final CartModel cart = _cartModel;

    return cart.shippingAddress?.summaryLine ?? '';
  }

  String _shippingCompanyLine() {
    final ShippingMethodModel? method = _cartModel.selectedShippingMethod;

    return method == null ? '' : method.displayTitle;
  }

  String _paymentMethodLine() => _cartModel.selectedPaymentMethod.displayTitle;

  /// `placeOrder` answers 200 with an `errors` list when it refuses, so a
  /// successful call is not a successful order — [PlaceOrderResponse.isSuccess]
  /// is what decides.
  Future<void> _placeOrder() async {
    if (_data.isPlacingOrder) return;

    _reviewCubit.onUpdateData(_data.copyWith(isPlacingOrder: true));

    // Read before the cart is cleared — the confirmation screen prints it.
    final double grandTotal = _cartModel.grandTotal;

    try {
      final Map<String, dynamic> json = await _graphql.mutate(
        GraphQLDocuments.placeOrder,
        variables: {'cartId': _cart.cartId},
      );

      final PlaceOrderResponse response = PlaceOrderResponse.fromJson(json);

      if (!response.isSuccess) {
        _alert.showError(
          response.errors.isEmpty
              ? LocaleKeys.somethingWentWrong.tr()
              : response.errors.first,
        );

        return;
      }

      await _cart.clearAfterOrder();

      // `goNamed`, not push: the quote is gone, so the three checkout steps
      // behind this must not stay on the stack to be walked back into.
      _nav.goNamed(
        RouteNames.orderConfirmed,
        extra: OrderConfirmedArgs(
          orderNumber: response.orderNumber,
          grandTotal: grandTotal,
        ),
      );
    } catch (error) {
      _alert.showError(errorMessageFrom(error));
    } finally {
      _reviewCubit.onUpdateData(_data.copyWith(isPlacingOrder: false));
    }
  }
}
