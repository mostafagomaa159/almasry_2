class ProductDetailsState {
  final int quantity;

  const ProductDetailsState({
    this.quantity = 0,
  });

  ProductDetailsState copyWith({
    int? quantity,
  }) {
    return ProductDetailsState(
      quantity: quantity ?? this.quantity,
    );
  }
}
