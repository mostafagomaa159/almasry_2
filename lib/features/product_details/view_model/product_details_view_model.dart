part of '../product_details_imports.dart';

/// Per-screen view model for [ProductDetailsView].
///
/// Also owns the display formatting and the favourite toggle that used to sit
/// in the view's `State`.
class ProductDetailsViewModel {
  /// Services

  final ApiService _apiService = sl<ApiService>();
  final FavoritesService _favorites = sl<FavoritesService>();
  final PushNotificationService _push = sl<PushNotificationService>();

  /// Variables

  final GenericCubit<ProductDetailsModel> _productDetailsCubit =
      GenericCubit<ProductDetailsModel>(const ProductDetailsModel());

  /// Route args, kept for the image/title fallbacks.
  ProductDetailsArgs? _args;

  ProductDetailsModel get _data => _productDetailsCubit.state.data;

  /// Init

  Future<void> _init({required ProductDetailsArgs args}) async {
    _args = args;
    await _getProductDetails(args.sku);
    await _loadNotifySubscription(args.sku);
  }

  void _dispose() {
    _productDetailsCubit.close();
  }

  /// Form state

  void _incrementQuantity() {
    final current = _productDetailsCubit.state.data;

    _productDetailsCubit.onUpdateData(
      current.copyWith(quantity: current.quantity + 1),
    );
  }

  void _decrementQuantity() {
    final current = _productDetailsCubit.state.data;

    if (current.quantity > 1) {
      _productDetailsCubit.onUpdateData(
        current.copyWith(quantity: current.quantity - 1),
      );
    }
  }

  /// Display values

  String _formatPrice(num? price) {
    if (price == null) return '';
    return '${price.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}';
  }

  String _getCustomAttributeValue(ProductModel product, String code) {
    try {
      final attribute = product.customAttributes?.firstWhere(
        (item) => item.attributeCode == code,
      );

      final value = attribute?.value;
      if (value == null) return '';

      if (value is List) {
        return value.join(', ');
      }

      return value.toString().trim();
    } catch (_) {
      return '';
    }
  }

  String _imagePathFor(ProductModel product) {
    return product.imageUrl.isNotEmpty
        ? product.imageUrl
        : (_args?.imagePath ?? '');
  }

  String _titleFor(ProductModel product) {
    return product.name.isNotEmpty ? product.name : (_args?.title ?? '');
  }

  String _descriptionFor(ProductModel product) {
    return product.description ?? '';
  }

  String _priceFor(ProductModel product) {
    return _formatPrice(product.price);
  }

  String _brandFor(ProductModel product) {
    return _getCustomAttributeValue(product, 'brand');
  }

  /// Placeholders, carried over verbatim from the view: the API does not supply
  /// these yet, so they were hardcoded there.
  String get _oldPrice => '';

  double get _rating => 0.0;

  /// Actions

  Future<void> _toggleFavorite(ProductModel product) async {
    final favoriteProduct = FavoriteProductModel(
      id: product.id.toString(),
      title: product.name,
      imagePath: product.imageUrl,
      price: product.price.toString(),
      oldPrice: '',
      category: '',
      description: product.description,
    );

    await _favorites.toggleFavorite(favoriteProduct);
  }

  void _addToBasket() {
    // TODO
  }

  /// Notify me when available

  Future<void> _loadNotifySubscription(String sku) async {
    final isSubscribed = await _push.isSubscribed(sku);

    if (!isSubscribed) return;

    _productDetailsCubit.onUpdateData(
      _productDetailsCubit.state.data.copyWith(isNotifySubscribed: true),
    );
  }

  /// Registers the device for an availability alert on [product].
  ///
  /// Takes the `BuildContext` for the confirmation snackbar only, matching how
  /// [OtpViewModel] does it — the work itself needs no context.
  Future<void> _notifyWhenAvailable(
    BuildContext context,
    ProductModel product,
  ) async {
    if (_data.isNotifyLoading) return;

    _productDetailsCubit.onUpdateData(
      _productDetailsCubit.state.data.copyWith(isNotifyLoading: true),
    );

    final success = await _push.subscribeToAvailability(
      sku: product.sku,
      productName: _titleFor(product),
      imagePath: _imagePathFor(product),
      notificationTitle: LocaleKeys.notificationProductAvailableTitle.tr(),
      notificationBody: LocaleKeys.notificationProductAvailableBody.tr(),
    );

    _productDetailsCubit.onUpdateData(
      _productDetailsCubit.state.data.copyWith(
        isNotifyLoading: false,
        isNotifySubscribed: success,
      ),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? LocaleKeys.productDetailsNotifyMeSuccess.tr()
              : LocaleKeys.productDetailsNotifyMeFailed.tr(),
        ),
      ),
    );
  }

  /// Helpers

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

    return e.message ?? LocaleKeys.somethingWentWrong.tr();
  }

  /// Api

  Future<ProductModel> _fetchProductDetails({required String sku}) async {
    final endPoint = '${ApiConstants.products}/$sku';

    final response = await _apiService.get(endPoint: endPoint);

    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> _getProductDetails(String sku) async {
    final current = _productDetailsCubit.state.data;

    _productDetailsCubit.onUpdateData(
      current.copyWith(isLoading: true, clearErrorMessage: true),
    );

    try {
      final product = await _fetchProductDetails(sku: sku);

      _productDetailsCubit.onUpdateData(
        _productDetailsCubit.state.data.copyWith(
          isLoading: false,
          product: product,
          clearErrorMessage: true,
        ),
      );
    } on DioException catch (e) {
      _productDetailsCubit.onUpdateData(
        _productDetailsCubit.state.data.copyWith(
          isLoading: false,
          errorMessage: _extractApiMessage(e),
        ),
      );
    } catch (e) {
      _productDetailsCubit.onUpdateData(
        _productDetailsCubit.state.data.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
