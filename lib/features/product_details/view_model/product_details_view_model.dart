part of '../product_details_imports.dart';

class ProductDetailsViewModel {
  /// Services
  final ApiService _apiService = sl<ApiService>();

  /// Cubit
  final GenericCubit<ProductDetailsModel> productDetailsCubit =
  GenericCubit<ProductDetailsModel>(const ProductDetailsModel());

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

  Future<ProductModel> _fetchProductDetails({
    required String sku,
  }) async {
    final endPoint = '${ApiConstants.products}/$sku';

    final response = await _apiService.get(
      endPoint: endPoint,
    );

    return ProductModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> init({required String sku}) async {
    await getProductDetails(sku);
  }

  Future<void> getProductDetails(String sku) async {
    final current = productDetailsCubit.state.data;

    productDetailsCubit.onUpdateData(
      current.copyWith(
        isLoading: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final product = await _fetchProductDetails(sku: sku);

      productDetailsCubit.onUpdateData(
        productDetailsCubit.state.data.copyWith(
          isLoading: false,
          product: product,
          clearErrorMessage: true,
        ),
      );
    } on DioException catch (e) {
      productDetailsCubit.onUpdateData(
        productDetailsCubit.state.data.copyWith(
          isLoading: false,
          errorMessage: _extractApiMessage(e),
        ),
      );
    } catch (e) {
      productDetailsCubit.onUpdateData(
        productDetailsCubit.state.data.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void incrementQuantity() {
    final current = productDetailsCubit.state.data;

    productDetailsCubit.onUpdateData(
      current.copyWith(quantity: current.quantity + 1),
    );
  }

  void decrementQuantity() {
    final current = productDetailsCubit.state.data;

    if (current.quantity > 1) {
      productDetailsCubit.onUpdateData(
        current.copyWith(quantity: current.quantity - 1),
      );
    }
  }


}
