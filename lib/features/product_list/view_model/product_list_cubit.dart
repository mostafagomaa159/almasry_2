part of '../product_list_imports.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final ApiService _apiService;

  ProductListCubit(this._apiService) : super(const ProductListState());

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

    return e.message ?? 'Something went wrong';
  }

  Future<List<ProductResponse>> _fetchProducts({
    required String categoryId,
  }) async {
    final endPoint =
        '${ApiConstants.products}'
        '?searchCriteria[filter_groups][0][filters][0][field]=category_id'
        '&searchCriteria[filter_groups][0][filters][0][value]=$categoryId'
        '&searchCriteria[filter_groups][0][filters][0][condition_type]=eq'
        '&searchCriteria[filter_groups][1][filters][0][field]=status'
        '&searchCriteria[filter_groups][1][filters][0][value]=1'
        '&searchCriteria[filter_groups][1][filters][0][condition_type]=eq'
        '&searchCriteria[pageSize]=20'
        '&searchCriteria[currentPage]=1';

    final response = await _apiService.get(
      endPoint: endPoint,
      options: _authOptions(),
    );

    final data = response.data;

    if (data is Map<String, dynamic> && data['items'] is List) {
      final items = data['items'] as List<dynamic>;

      return items
          .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  Future<void> loadProducts({
    required String title,
    required String categoryId,
  }) async {
    emit(
      state.copyWith(
        status: ProductListStatus.loading,
        title: title,
        categoryId: categoryId,
        clearErrorMessage: true,
      ),
    );

    try {
      final products = await _fetchProducts(categoryId: categoryId);

      emit(
        state.copyWith(
          status: ProductListStatus.success,
          products: products,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: ProductListStatus.error,
          errorMessage: _extractApiMessage(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductListStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
