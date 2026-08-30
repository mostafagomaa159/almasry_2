import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_graphql.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/models/request/cart/cart_item_request.dart';
import 'package:almasry_2/core/models/response/cart/cart_data_model.dart';
import 'package:almasry_2/core/models/response/cart/cart_item_model.dart';
import 'package:almasry_2/core/models/response/cart/cart_model.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/alert_service.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:almasry_2/core/services/navigation_service.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:almasry_2/core/utils/error_message.dart';
import 'package:easy_localization/easy_localization.dart';

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

  /// Set by the OTP login. With it, the cart is the account's own; without it
  /// — the email/password path, whose endpoint is still a stub — it is a guest
  /// cart that needs an email before Magento will take the order.
  bool get hasCustomerToken =>
      _prefs.getString(PrefKeys.customerToken).trim().isNotEmpty;

  /// A customer session begins: whatever masked id is on the device belonged
  /// to whoever was here before, so it is dropped and the account's own cart
  /// is read in its place.
  Future<void> adoptCustomerCart() async {
    await _prefs.remove(PrefKeys.cartId);

    await loadCart();
  }

  /// The basket belongs to the account that was signed in, so signing out
  /// takes it off this device with the session.
  Future<void> clearForLogout() async {
    await _prefs.remove(PrefKeys.cartId);

    _emit(const CartData(status: CartStatus.success));
  }

  Future<void> loadCart() async {
    // A signed-in customer has a cart server-side even on a fresh install, so
    // there is something to fetch before there is anything stored.
    if (!hasCart && hasCustomerToken) {
      _emit(data.copyWith(status: CartStatus.loading, clearErrorMessage: true));

      final String id = await ensureCartId();

      if (id.isEmpty) return;

      await _readCart();

      return;
    }

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

  Future<void> refresh() async {
    if (!hasCart) return loadCart();

    await _readCart();
  }

  Future<String> ensureCartId() async {
    final String existing = cartId;

    if (existing.trim().isNotEmpty) return existing;

    if (hasCustomerToken) {
      final String customerCartId = await _customerCartId();

      if (customerCartId.isNotEmpty) return customerCartId;
    }

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

  /// Adding is where the app asks who you are. A basket belongs to an account,
  /// so an anonymous tap raises the sign-in prompt instead of minting a cart —
  /// either sign-in counts, the email one or the phone/OTP one, since both
  /// leave [PrefKeys.isLoggedIn] set.
  bool get isLoggedIn => _prefs.getBool(PrefKeys.isLoggedIn);

  /// Asked, not announced: the prompt waits for an answer, and the screen the
  /// tap came from stays where it is unless the answer is yes. Declining is
  /// not a failure either, so the error message is cleared on the way out and
  /// no screen reports one over the prompt.
  void _askToSignIn() {
    _emit(data.copyWith(clearErrorMessage: true));

    sl<AlertService>().showConfirmation(
      title: LocaleKeys.signInToContinue.tr(),
      confirmTitle: LocaleKeys.confirm.tr(),
      cancelTitle: LocaleKeys.cancel.tr(),
      onConfirm: () => sl<NavigationService>().pushNamed(RouteNames.login),
    );
  }

  Future<bool> addToCart({required String sku, int quantity = 1}) async {
    final String trimmedSku = sku.trim();

    if (trimmedSku.isEmpty || quantity <= 0) return false;

    if (!isLoggedIn) {
      _askToSignIn();

      return false;
    }

    _emit(
      data.copyWith(
        addingSkus: <String>{...data.addingSkus, trimmedSku},
        clearErrorMessage: true,
      ),
    );

    final String id = await ensureCartId();

    if (id.isEmpty) {
      _clearAdding(trimmedSku);

      return false;
    }

    final bool succeeded = await _mutateCart(
      document: GraphQLDocuments.addSimpleProductsToCart,
      mutationKey: 'addSimpleProductsToCart',
      variables: AddToCartRequest(
        cartId: id,
        sku: trimmedSku,
        quantity: quantity,
      ).toVariables(),
    );

    _clearAdding(trimmedSku);

    return succeeded;
  }

  /// `customerCart` over `createEmptyCart` for a signed-in customer: it hands
  /// back the account's existing quote rather than opening a second one. A
  /// failure here is not reported — the caller falls through to
  /// `createEmptyCart`, which under the same token also lands on the customer.
  Future<String> _customerCartId() async {
    try {
      final Map<String, dynamic> response = await _graphql.query(
        GraphQLDocuments.customerCart,
      );

      final String id =
          (response['customerCart'] as Map<String, dynamic>?)?['id']
              ?.toString() ??
          '';

      if (id.trim().isEmpty) return '';

      await _prefs.setString(PrefKeys.cartId, id);

      return id;
    } catch (_) {
      return '';
    }
  }

  void _clearAdding(String sku) {
    _emit(data.copyWith(addingSkus: <String>{...data.addingSkus}..remove(sku)));
  }

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
