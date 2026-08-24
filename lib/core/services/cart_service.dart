import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_graphql.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/models/request/cart/cart_item_request.dart';
import 'package:almasry_2/core/models/response/cart/cart_data_model.dart';
import 'package:almasry_2/core/models/response/cart/cart_item_model.dart';
import 'package:almasry_2/core/models/response/cart/cart_model.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:almasry_2/core/utils/error_message.dart';

/// The one owner of the cart: the masked cart id, its lifecycle, and every
/// mutation that touches it.
///
/// The cart is cross-screen state — the bottom bar badge, product details, the
/// cart screen and all three checkout steps read it — so it is a
/// locator-registered singleton with public members rather than a per-screen
/// ViewModel.
///
/// Every mutation selects the whole cart back (see
/// `GraphQLDocuments.cartFragment`), so one round trip both applies the change
/// and refreshes the state. Callers get a `bool` and the failure message is
/// already on the cubit — no screen has to translate an exception.
class CartService {
  final GenericCubit<CartData> cartCubit = GenericCubit<CartData>(
    const CartData(),
  );

  GraphQLService get _graphql => sl<GraphQLService>();

  SharedPrefsServices get _prefs => sl<SharedPrefsServices>();

  CartData get data => cartCubit.state.data;

  CartModel get cart => data.cart;

  String get cartId => _prefs.getString(PrefKeys.cartId);

  bool get hasCart => cartId.trim().isNotEmpty;

  /// Reads the persisted cart, if there is one. A missing id is not an error —
  /// it is simply an empty cart, and none is created until something is added.
  Future<void> loadCart() async {
    if (!hasCart) {
      _emit(
        data.copyWith(
          status: CartStatus.success,
          cart: const CartModel(),
          clearErrorMessage: true,
        ),
      );

      return;
    }

    _emit(data.copyWith(status: CartStatus.loading, clearErrorMessage: true));

    await _readCart();
  }

  /// Re-reads without dropping what is on screen, for pull-to-refresh and for
  /// coming back to the cart after a checkout step changed the totals.
  Future<void> refresh() async {
    if (!hasCart) return loadCart();

    await _readCart();
  }

  /// Mints a cart on first use and keeps the id. Returns an empty string when
  /// `createEmptyCart` itself fails, which is the one case a caller has to
  /// check before sending anything else.
  Future<String> ensureCartId() async {
    final String existing = cartId;

    if (existing.trim().isNotEmpty) return existing;

    try {
      final Map<String, dynamic> response = await _graphql.mutate(
        GraphQLDocuments.createEmptyCart,
      );

      final String created = response['createEmptyCart']?.toString() ?? '';

      if (created.trim().isEmpty) {
        _emit(data.copyWith(status: CartStatus.error, errorMessage: ''));

        return '';
      }

      await _prefs.setString(PrefKeys.cartId, created);

      return created;
    } catch (error) {
      _emit(
        data.copyWith(
          status: CartStatus.error,
          errorMessage: errorMessageFrom(error),
        ),
      );

      return '';
    }
  }

  Future<bool> addProduct({required String sku, int quantity = 1}) async {
    if (sku.trim().isEmpty || quantity <= 0) return false;

    _emit(data.copyWith(isAdding: true, clearErrorMessage: true));

    final String id = await ensureCartId();

    if (id.isEmpty) {
      _emit(data.copyWith(isAdding: false));

      return false;
    }

    final bool succeeded = await _mutateCart(
      document: GraphQLDocuments.addSimpleProductsToCart,
      mutationKey: 'addSimpleProductsToCart',
      variables: AddToCartRequest(
        cartId: id,
        sku: sku.trim(),
        quantity: quantity,
      ).toVariables(),
    );

    _emit(data.copyWith(isAdding: false));

    return succeeded;
  }

  /// A [quantity] of 0 or less removes the line instead — which is what the
  /// stepper's minus button does on the last unit.
  Future<bool> updateQuantity({
    required CartItemModel item,
    required int quantity,
  }) async {
    if (quantity <= 0) return removeItem(item);

    return _withItemBusy(
      item,
      () => _mutateCart(
        document: GraphQLDocuments.updateCartItems,
        mutationKey: 'updateCartItems',
        variables: UpdateCartItemRequest(
          cartId: cartId,
          cartItemId: item.numericId,
          quantity: quantity,
        ).toVariables(),
      ),
    );
  }

  Future<bool> removeItem(CartItemModel item) {
    return _withItemBusy(
      item,
      () => _mutateCart(
        document: GraphQLDocuments.removeItemFromCart,
        mutationKey: 'removeItemFromCart',
        variables: RemoveCartItemRequest(
          cartId: cartId,
          cartItemId: item.numericId,
        ).toVariables(),
      ),
    );
  }

  /// Called once an order is placed: Magento has already consumed the quote,
  /// so the id has to go or every later call fails against a dead cart.
  Future<void> clearAfterOrder() async {
    await _prefs.remove(PrefKeys.cartId);

    _emit(const CartData(status: CartStatus.success));
  }

  void dispose() {
    cartCubit.close();
  }

  Future<bool> _withItemBusy(
    CartItemModel item,
    Future<bool> Function() action,
  ) async {
    if (!hasCart || item.numericId <= 0) return false;

    _emit(
      data.copyWith(
        busyItemIds: <int>{...data.busyItemIds, item.numericId},
        clearErrorMessage: true,
      ),
    );

    final bool succeeded = await action();

    _emit(
      data.copyWith(
        busyItemIds: <int>{...data.busyItemIds}..remove(item.numericId),
      ),
    );

    return succeeded;
  }

  Future<void> _readCart() async {
    try {
      final Map<String, dynamic> response = await _graphql.query(
        GraphQLDocuments.getCartDetails,
        variables: {'cartId': cartId},
      );

      _emit(
        data.copyWith(
          status: CartStatus.success,
          cart: CartModel.fromResponse(response),
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      await _handleFailure(error);
    }
  }

  Future<bool> _mutateCart({
    required String document,
    required String mutationKey,
    required Map<String, dynamic> variables,
  }) async {
    try {
      final Map<String, dynamic> response = await _graphql.mutate(
        document,
        variables: variables,
      );

      _emit(
        data.copyWith(
          status: CartStatus.success,
          cart: CartModel.fromResponse(response, mutationKey: mutationKey),
          clearErrorMessage: true,
        ),
      );

      return true;
    } catch (error) {
      await _handleFailure(error);

      return false;
    }
  }

  /// A cart id Magento no longer knows — expired, or already turned into an
  /// order — has to be dropped rather than reported, otherwise the app is
  /// stuck on an error it can never retry out of.
  Future<void> _handleFailure(Object error) async {
    final String message = errorMessageFrom(error);

    if (_isMissingCart(message)) {
      await _prefs.remove(PrefKeys.cartId);

      _emit(const CartData(status: CartStatus.success));

      return;
    }

    _emit(data.copyWith(status: CartStatus.error, errorMessage: message));
  }

  bool _isMissingCart(String message) {
    final String lower = message.toLowerCase();

    return lower.contains('could not find a cart') ||
        lower.contains('cannot perform operations on cart') ||
        lower.contains('no such entity with cart_id');
  }

  void _emit(CartData next) => cartCubit.onUpdateData(next);
}
