import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/app_graphql.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/models/request/cart/cart_item_request.dart';
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
  final GenericCubit<CartModel> cartCubit = GenericCubit<CartModel>(
    const CartModel(),
  );

  final GenericCubit<bool> loadingCubit = GenericCubit<bool>(false);

  final GenericCubit<Set<int>> busyItemsCubit = GenericCubit<Set<int>>(
    const <int>{},
  );

  final GenericCubit<Set<String>> addingSkusCubit = GenericCubit<Set<String>>(
    const <String>{},
  );

  String errorMessage = '';

  final _graphqlService = sl<GraphQLService>();
  final _prefsService = sl<SharedPrefsServices>();
  final _alertService = sl<AlertService>();
  final _navService = sl<NavigationService>();

  CartModel get cart => cartCubit.state.data;

  Set<int> get busyItemIds => busyItemsCubit.state.data;

  Set<String> get addingSkus => addingSkusCubit.state.data;

  String get cartId => _prefsService.getString(PrefKeys.cartId);

  bool get hasCart => cartId.trim().isNotEmpty;

  bool get hasCustomerToken =>
      _prefsService.getString(PrefKeys.customerToken).trim().isNotEmpty;

  Future<void> adoptCustomerCart() async {
    await _prefsService.remove(PrefKeys.cartId);

    await loadCart();
  }

  Future<void> clearForLogout() async {
    await _prefsService.remove(PrefKeys.cartId);

    errorMessage = '';

    cartCubit.onUpdateData(const CartModel());
  }

  Future<void> loadCart() async {
    if (!hasCart && !hasCustomerToken) {
      errorMessage = '';

      cartCubit.onUpdateData(const CartModel());

      return;
    }

    errorMessage = '';

    loadingCubit.onUpdateData(true);

    try {
      if (!hasCart) {
        final String id = await ensureCartId();

        if (id.isEmpty) return;
      }

      await _readCart();
    } finally {
      loadingCubit.onUpdateData(false);
    }
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
      final Map<String, dynamic> response = await _graphqlService.mutate(
        GraphQLDocuments.createEmptyCart,
      );

      final String created = response['createEmptyCart']?.toString() ?? '';

      if (created.trim().isEmpty) {
        errorMessage = '';

        cartCubit.onUpdateData(cart);

        return '';
      }

      await _prefsService.setString(PrefKeys.cartId, created);

      return created;
    } catch (error) {
      errorMessage = errorMessageFrom(error);

      cartCubit.onUpdateData(cart);

      return '';
    }
  }

  bool get isLoggedIn => _prefsService.getBool(PrefKeys.isLoggedIn);

  void _askToSignIn() {
    errorMessage = '';

    _alertService.showConfirmation(
      title: LocaleKeys.signInToContinue.tr(),
      confirmTitle: LocaleKeys.confirm.tr(),
      cancelTitle: LocaleKeys.cancel.tr(),
      onConfirm: () => _navService.pushNamed(RouteNames.login),
    );
  }

  Future<bool> addToCart({required String sku, int quantity = 1}) async {
    final String trimmedSku = sku.trim();

    if (trimmedSku.isEmpty || quantity <= 0) return false;

    if (!isLoggedIn) {
      _askToSignIn();

      return false;
    }

    errorMessage = '';

    addingSkusCubit.onUpdateData(<String>{...addingSkus, trimmedSku});

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

  void _clearAdding(String sku) {
    addingSkusCubit.onUpdateData(<String>{...addingSkus}..remove(sku));
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
    await _prefsService.remove(PrefKeys.cartId);

    errorMessage = '';

    cartCubit.onUpdateData(const CartModel());
  }

  void dispose() {
    cartCubit.close();
    loadingCubit.close();
    busyItemsCubit.close();
    addingSkusCubit.close();
  }

  Future<bool> _withItemBusy(
    CartItemModel item,
    Future<bool> Function() action,
  ) async {
    if (!hasCart || item.numericId <= 0) return false;

    errorMessage = '';

    busyItemsCubit.onUpdateData(<int>{...busyItemIds, item.numericId});

    final bool succeeded = await action();

    busyItemsCubit.onUpdateData(<int>{...busyItemIds}..remove(item.numericId));

    return succeeded;
  }

  Future<void> _readCart() async {
    try {
      final Map<String, dynamic> response = await _graphqlService.query(
        GraphQLDocuments.getCartDetails,
        variables: {'cartId': cartId},
      );

      errorMessage = '';

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

      errorMessage = '';

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
      await _prefsService.remove(PrefKeys.cartId);

      errorMessage = '';

      cartCubit.onUpdateData(const CartModel());

      return;
    }

    errorMessage = message;

    cartCubit.onUpdateData(cart);
  }

  bool _isMissingCart(String message) {
    final String lower = message.toLowerCase();

    return lower.contains('could not find a cart') ||
        lower.contains('cannot perform operations on cart') ||
        lower.contains('no such entity with cart_id');
  }
}
