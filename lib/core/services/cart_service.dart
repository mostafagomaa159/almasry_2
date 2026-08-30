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


  Future<void> refresh() async {
    if (!hasCart) return loadCart();

    await _readCart();
  }

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
    final String trimmedSku = sku.trim();

    if (trimmedSku.isEmpty || quantity <= 0) return false;

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


  void _clearAdding(String sku) {
    _emit(
      data.copyWith(addingSkus: <String>{...data.addingSkus}..remove(sku)),
    );
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
