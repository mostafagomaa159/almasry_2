/// Variables for [GraphQLDocuments.addSimpleProductsToCart].
class AddToCartRequest {
  final String cartId;
  final String sku;
  final int quantity;

  const AddToCartRequest({
    required this.cartId,
    required this.sku,
    required this.quantity,
  });

  /// `quantity` is a GraphQL `Float!`, so it goes over the wire as a double
  /// even though the UI only ever deals in whole units.
  Map<String, dynamic> toVariables() {
    return {'cartId': cartId, 'sku': sku, 'quantity': quantity.toDouble()};
  }
}

/// Variables for [GraphQLDocuments.updateCartItems]. A [quantity] of 0 is how
/// Magento is told to drop the line.
class UpdateCartItemRequest {
  final String cartId;
  final int cartItemId;
  final int quantity;

  const UpdateCartItemRequest({
    required this.cartId,
    required this.cartItemId,
    required this.quantity,
  });

  Map<String, dynamic> toVariables() {
    return {
      'cartId': cartId,
      'cartItemId': cartItemId,
      'quantity': quantity.toDouble(),
    };
  }
}

/// Variables for [GraphQLDocuments.removeItemFromCart].
class RemoveCartItemRequest {
  final String cartId;
  final int cartItemId;

  const RemoveCartItemRequest({required this.cartId, required this.cartItemId});

  Map<String, dynamic> toVariables() {
    return {'cartId': cartId, 'cartItemId': cartItemId};
  }
}
