part of '../product_details_imports.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ApiService _apiService;

  ProductDetailsCubit(this._apiService)
      : super(const ProductDetailsState());

  Options _authOptions() {
    return Options(
      headers: {
        'Authorization': 'Bearer ${ApiConstants.token}',
      },
    );
  }

  String _extractApiMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    if (data is Map) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return e.message ?? 'حدث خطأ غير متوقع';
  }

  Future<ProductResponse> _fetchProductDetails({
    required String sku,
  }) async {
    final endPoint = '${ApiConstants.products}/$sku';

    final response = await _apiService.get(
      endPoint: endPoint,
      options: _authOptions(),
    );

    return ProductResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> getProductDetails(String sku) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final product = await _fetchProductDetails(sku: sku);

      emit(
        state.copyWith(
          isLoading: false,
          product: product,
          clearErrorMessage: true,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: _extractApiMessage(e),
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
