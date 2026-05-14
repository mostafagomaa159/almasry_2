part of '../product_details_imports.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(const ProductDetailsState());

  void incrementQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrementQuantity() {
    if (state.quantity > 0) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }
}
