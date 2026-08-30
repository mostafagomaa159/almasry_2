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

  /// Skus with an add in flight. A set rather than a single flag because the
  /// product grids show many cards off this one cubit — a plain bool would put
  /// every card on the screen into a spinner for one tap.
  final Set<String> addingSkus;

  const CartData({
    this.status = CartStatus.initial,
    this.cart = const CartModel(),
    this.errorMessage = '',
    this.busyItemIds = const <int>{},
    this.addingSkus = const <String>{},
  });

  CartData copyWith({
    CartStatus? status,
    CartModel? cart,
    String? errorMessage,
    Set<int>? busyItemIds,
    Set<String>? addingSkus,
    bool clearErrorMessage = false,
  }) {
    return CartData(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: clearErrorMessage
          ? ''
          : (errorMessage ?? this.errorMessage),
      busyItemIds: busyItemIds ?? this.busyItemIds,
      addingSkus: addingSkus ?? this.addingSkus,
    );
  }

  bool get isLoading => status == CartStatus.loading;

  /// What the bottom bar badge shows. Zero until the first successful read, so
  /// a failed request does not paint a stale count.
  int get badgeCount => status == CartStatus.success ? cart.totalQuantity : 0;

  bool isItemBusy(int itemId) => busyItemIds.contains(itemId);

  /// What a product card reads, so only the tapped card spins.
  bool isAddingSku(String sku) => addingSkus.contains(sku.trim());

  /// Any add at all — for a single-product screen, where there is only one.
  bool get isAdding => addingSkus.isNotEmpty;
}
