import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_graphql.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/models/request/cart/cart_item_request.dart';
import 'package:almasry_2/core/models/response/cart/cart_item_model.dart';
import 'package:almasry_2/core/models/response/cart/cart_model.dart';
import 'package:almasry_2/core/routing/app_routes.dart';
import 'package:almasry_2/core/services/alert_service.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:almasry_2/core/services/navigation_service.dart';
import 'package:almasry_2/core/services/shared_prefs_services.dart';
import 'package:almasry_2/core/utils/error_message.dart';
import 'package:easy_localization/easy_localization.dart';

class CartService {
  final GenericCubit<CartModel> cartCubit = GenericCubit<CartModel>(
    const CartModel(),
  );
  final GenericCubit<bool> loadingCubit = GenericCubit<bool>(false);
  final _graphqlService = sl<GraphQLService>();
  final _prefsService = sl<SharedPrefsServices>();
  final _alertService = sl<AlertService>();
  final _navService = sl<NavigationService>();

  CartModel get cart => cartCubit.state.data;

  String get cartId => _prefsService.getString(PrefKeys.cartId);

  bool get hasCartId => cartId.trim().isNotEmpty;

  bool get hasCustomerToken =>
      _prefsService.getString(PrefKeys.customerToken).trim().isNotEmpty;

  bool get isLoggedIn => _prefsService.getBool(PrefKeys.isLoggedIn);

  Future<void> loadCart() async {
    final String id = await resolveCartId();

    if (id.isEmpty) {
      cartCubit.onUpdateData(const CartModel());

      return;
    }

    loadingCubit.onUpdateData(true);

    try {
      await _readCart(id);
    } finally {
      loadingCubit.onUpdateData(false);
    }
  }

  Future<String> resolveCartId() async {
    final String stored = cartId;

    if (stored.trim().isNotEmpty) return stored;

    if (!hasCustomerToken) return '';

    return _customerCartId();
  }

  Future<String> ensureCartId() async {
    final String resolved = await resolveCartId();

    if (resolved.trim().isNotEmpty) return resolved;

    final Map<String, dynamic> response = await _graphqlService.mutate(
      GraphQLDocuments.createEmptyCart,
    );

    final String created = response['createEmptyCart']?.toString() ?? '';

    if (created.trim().isEmpty) return '';

    await _prefsService.setString(PrefKeys.cartId, created);

    return created;
  }

  Future<bool> addToCart({required String sku, int quantity = 1}) async {
    final String trimmedSku = sku.trim();

    if (trimmedSku.isEmpty || quantity <= 0) return false;

    if (!isLoggedIn) {
      _askToSignIn();

      return false;
    }

    try {
      final String id = await ensureCartId();

      if (id.isEmpty) return false;

      return _mutateCart(
        document: GraphQLDocuments.addSimpleProductsToCart,
        mutationKey: 'addSimpleProductsToCart',
        variables: AddToCartRequest(
          cartId: id,
          sku: trimmedSku,
          quantity: quantity,
        ).toVariables(),
      );
    } catch (error) {
      await _handleFailure(error);

      return false;
    }
  }

  Future<bool> updateQuantity({
    required CartItemModel item,
    required int quantity,
  }) {
    if (quantity <= 0) return removeItem(item);
    return _mutateCart(
      document: GraphQLDocuments.updateCartItems,
      mutationKey: 'updateCartItems',
      variables: UpdateCartItemRequest(
        cartId: cartId,
        cartItemId: item.numericId,
        quantity: quantity,
      ).toVariables(),
    );
  }

  Future<bool> removeItem(CartItemModel item) {
    return _mutateCart(
      document: GraphQLDocuments.removeItemFromCart,
      mutationKey: 'removeItemFromCart',
      variables: RemoveCartItemRequest(
        cartId: cartId,
        cartItemId: item.numericId,
      ).toVariables(),
    );
  }

  Future<void> adoptCustomerCart() async {
    await _prefsService.remove(PrefKeys.cartId);

    await loadCart();
  }

  Future<void> clearCart() async {
    await _prefsService.remove(PrefKeys.cartId);

    cartCubit.onUpdateData(const CartModel());
  }

  void dispose() {
    cartCubit.close();
    loadingCubit.close();
  }

  void _askToSignIn() {
    _alertService.showConfirmation(
      title: LocaleKeys.signInToContinue.tr(),
      confirmTitle: LocaleKeys.confirm.tr(),
      cancelTitle: LocaleKeys.cancel.tr(),
      onConfirm: () => _navService.pushNamed(RouteNames.login),
    );
  }

  Future<String> _customerCartId() async {
    try {
      final Map<String, dynamic> response = await _graphqlService.query(
        GraphQLDocuments.customerCart,
      );

      final String id =
          (response['customerCart'] as Map<String, dynamic>?)?['id']
              ?.toString() ??
          '';

      if (id.trim().isEmpty) return '';

      await _prefsService.setString(PrefKeys.cartId, id);

      return id;
    } catch (_) {
      return '';
    }
  }

  Future<void> _readCart(String id) async {
    try {
      final Map<String, dynamic> response = await _graphqlService.query(
        GraphQLDocuments.getCartDetails,
        variables: <String, dynamic>{'cartId': id},
      );

      cartCubit.onUpdateData(CartModel.fromResponse(response));
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
      final Map<String, dynamic> response = await _graphqlService.mutate(
        document,
        variables: variables,
      );

      cartCubit.onUpdateData(
        CartModel.fromResponse(response, mutationKey: mutationKey),
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
      await clearCart();

      return;
    }

    _alertService.showError(message);

    cartCubit.onUpdateData(cart);
  }

  bool _isMissingCart(String message) {
    final String lower = message.toLowerCase();

    return lower.contains('could not find a cart') ||
        lower.contains('cannot perform operations on cart') ||
        lower.contains('no such entity with cart_id');
  }
}
