part of '../checkout_review_imports.dart';

class CheckoutReviewViewModel {
  final _graphqlService = sl<GraphQLService>();
  final _navService = sl<NavigationService>();
  final _alertService = sl<AlertService>();
  final _cartService = sl<CartService>();

  final GenericCubit<bool> _productsExpandedCubit = GenericCubit<bool>(true);
  final GenericCubit<bool> _orderExpandedCubit = GenericCubit<bool>(true);
  final GenericCubit<bool> _billExpandedCubit = GenericCubit<bool>(true);

  final GenericCubit<bool> _placingOrderCubit = GenericCubit<bool>(false);

  late final GenericCubit<CartModel> _cartCubit = _cartService.cartCubit;

  CartModel _cartModel() => _cartService.cart;

  void _init() {}

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

  Future<void> _placeOrder() async {
    if (_placingOrderCubit.state.data) return;

    _placingOrderCubit.onUpdateData(true);

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
