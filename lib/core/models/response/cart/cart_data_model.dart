import 'package:almasry_2/core/models/response/cart/cart_model.dart';

/// [CartStatus.initial] is before the first read — distinct from
/// [CartStatus.success] with no items, which is the empty-cart screen.
enum CartStatus { initial, loading, success, error }

/// The state `CartService` publishes. It is app-global, so it lives beside the
/// cart models rather than inside a feature.
class CartData {
  final CartStatus status;
  final CartModel cart;
  final String errorMessage;

  /// Cart-item ids with a mutation in flight, so a row can spin its own
  /// stepper without the whole list going into a skeleton.
  final Set<int> busyItemIds;

  /// True while a product is being added from another screen — what the
  /// product details button reads for its spinner.
  final bool isAdding;

  const CartData({
    this.status = CartStatus.initial,
    this.cart = const CartModel(),
    this.errorMessage = '',
    this.busyItemIds = const <int>{},
    this.isAdding = false,
  });

  CartData copyWith({
    CartStatus? status,
    CartModel? cart,
    String? errorMessage,
    Set<int>? busyItemIds,
    bool? isAdding,
    bool clearErrorMessage = false,
  }) {
    return CartData(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: clearErrorMessage
          ? ''
          : (errorMessage ?? this.errorMessage),
      busyItemIds: busyItemIds ?? this.busyItemIds,
      isAdding: isAdding ?? this.isAdding,
    );
  }

  bool get isLoading => status == CartStatus.loading;

  /// What the bottom bar badge shows. Zero until the first successful read, so
  /// a failed request does not paint a stale count.
  int get badgeCount => status == CartStatus.success ? cart.totalQuantity : 0;

  bool isItemBusy(int itemId) => busyItemIds.contains(itemId);
}
