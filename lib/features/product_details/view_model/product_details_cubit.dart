part of '../product_details_imports.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductsRepository productsRepository;

  ProductDetailsCubit(this.productsRepository)
      : super(const ProductDetailsState());

  Future<void> getProductDetails(String sku) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final product = await productsRepository.getProductDetails(
        sku: sku,
      );

      emit(
        state.copyWith(
          isLoading: false,
          product: product,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }


  void incrementQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }
}
