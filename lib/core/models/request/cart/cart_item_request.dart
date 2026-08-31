class AddToCartRequest {
  final String cartId;
  final String sku;
  final int quantity;

  const AddToCartRequest({
    required this.cartId,
    required this.sku,
    required this.quantity,
  });

  Map<String, dynamic> toVariables() {
    return {'cartId': cartId, 'sku': sku, 'quantity': quantity.toDouble()};
  }
}

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

class RemoveCartItemRequest {
  final String cartId;
  final int cartItemId;

  const RemoveCartItemRequest({required this.cartId, required this.cartItemId});

  Map<String, dynamic> toVariables() {
    return {'cartId': cartId, 'cartItemId': cartItemId};
  }
}
