part of '../product_details_imports.dart';

typedef ListRelatedProducts = List<ProductRelatedItemModel>;

class ProductDetailsViewModel {
  final _graphqlService = sl<GraphQLService>();
  final _navService = sl<NavigationService>();
  final _favoritesService = sl<FavoritesService>();
  final _pushService = sl<PushNotificationService>();
  final _alertService = sl<AlertService>();
  final _cartService = sl<CartService>();

  static const int _brandProductsPageSize = 10;

  final GenericCubit<ProductDetailModel?> _productCubit =
      GenericCubit<ProductDetailModel?>(null);

  final GenericCubit<int> _quantityCubit = GenericCubit<int>(1);
  final GenericCubit<int> _selectedImageCubit = GenericCubit<int>(0);
  final GenericCubit<bool> _descriptionCubit = GenericCubit<bool>(false);

  final GenericCubit<bool> _notifySubscribedCubit = GenericCubit<bool>(false);
  final GenericCubit<bool> _notifyLoadingCubit = GenericCubit<bool>(false);

  final GenericCubit<ListRelatedProducts> _brandProductsCubit =
      GenericCubit<ListRelatedProducts>([]);
  final GenericCubit<bool> _brandProductsLoadingCubit = GenericCubit<bool>(
    false,
  );

  final PageController _imagePageController = PageController();
  final ScrollController _thumbnailsController = ScrollController();

  ProductDetailsArgs? _args;

  String _errorMessage = '';

  ProductDetailModel? _product() => _productCubit.state.data;

  int _quantity() => _quantityCubit.state.data;

  late final GenericCubit<ListFavorites> _favoritesCubit =
      _favoritesService.favoritesCubit;

  late final GenericCubit<Set<String>> _addingSkusCubit =
      _cartService.addingSkusCubit;

  Future<void> _init({required ProductDetailsArgs args}) async {
    _args = args;

    await _favoritesService.loadFavorites();
    await _getProductDetails(args.sku);
    await _loadNotifySubscription(args.sku);
  }

  void _dispose() {
    _imagePageController.dispose();
    _thumbnailsController.dispose();
  }

  void _back() {
    _navService.pop();
  }

  void _incrementQuantity() {
    _quantityCubit.onUpdateData(_quantity() + 1);
  }

  void _decrementQuantity() {
    if (_quantity() <= 1) return;

    _quantityCubit.onUpdateData(_quantity() - 1);
  }

  void _toggleDescription() {
    _descriptionCubit.onUpdateData(!_descriptionCubit.state.data);
  }

  void _selectImage(int index) {
    if (index == _selectedImageIndex()) return;

    if (!_imagePageController.hasClients) {
      _onImagePageChanged(index);

      return;
    }

    _imagePageController.animateToPage(
      index,
      duration: AppDurations.page,
      curve: Curves.easeInOut,
    );
  }

  void _onImagePageChanged(int index) {
    if (index != _selectedImageCubit.state.data) {
      _selectedImageCubit.onUpdateData(index);
    }

    _centerThumbnail(index);
  }

  void _centerThumbnail(int index) {
    if (!_thumbnailsController.hasClients) return;

    final ScrollPosition position = _thumbnailsController.position;

    final double target =
        (index * _thumbnailExtent()) +
        (_thumbnailExtent() / 2) -
        (position.viewportDimension / 2);

    _thumbnailsController.animateTo(
      target.clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: AppDurations.page,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _addToCart() async {
    final String sku = _product()?.sku ?? _args?.sku ?? '';

    if (sku.trim().isEmpty) return;

    if (await _cartService.addToCart(sku: sku, quantity: _quantity())) {
      _alertService.showSuccess(LocaleKeys.cartAddedSuccess.tr());

      return;
    }

    final String message = _cartService.errorMessage;

    if (message.trim().isEmpty) return;

    _alertService.showError(message);
  }

  void _addReview() {
    _navService.pushNamed(
      RouteNames.homeComingSoon,
      extra: LocaleKeys.productDetailsAddReview.tr(),
    );
  }

  void _openRelatedProduct(ProductRelatedItemModel item) {
    if (item.sku.trim().isEmpty) return;

    _navService.pushNamed(
      RouteNames.productDetails,
      extra: ProductDetailsArgs(
        sku: item.sku,
        title: item.name,
        imagePath: item.thumbnailUrl,
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    final ProductDetailModel? product = _product();

    if (product == null) return;

    await _favoritesService.toggleFavorite(
      FavoriteProductModel(
        id: product.sku,
        title: product.name,
        imagePath: _imagePath(),
        price: product.finalPrice.toStringAsFixed(2),
        oldPrice: product.hasDiscount
            ? product.regularPrice.toStringAsFixed(2)
            : '',
        category: product.categories.isEmpty
            ? ''
            : product.categories.first.name,
        description: product.shortDescriptionHtml,
      ),
    );
  }

  String _title() {
    final String name = _product()?.name ?? '';

    return name.isNotEmpty ? name : (_args?.title ?? '');
  }

  String _imagePath() {
    final String url = _product()?.imageUrl ?? '';

    return url.isNotEmpty ? url : (_args?.imagePath ?? '');
  }

  String _sku() => _product()?.sku ?? _args?.sku ?? '';

  List<String> _galleryImages() {
    final List<String> urls = _product()?.galleryUrls ?? const [];

    if (urls.isNotEmpty) return urls;

    return _imagePath().isEmpty ? const [] : [_imagePath()];
  }

  int _selectedImageIndex() {
    final int count = _galleryImages().length;

    if (count == 0) return 0;

    return _selectedImageCubit.state.data.clamp(0, count - 1);
  }

  double _thumbnailExtent() => 74.w + 10.w;

  String _formatPrice(double? price) {
    if (price == null || price <= 0) return '';

    return '${LocaleKeys.currencyShort.tr()} ${price.toStringAsFixed(2)}';
  }

  Future<void> _loadNotifySubscription(String sku) async {
    final bool isSubscribed = await _pushService.isSubscribed(sku);

    if (!isSubscribed || _notifySubscribedCubit.isClosed) return;

    _notifySubscribedCubit.onUpdateData(true);
  }

  Future<void> _notifyWhenAvailable() async {
    final ProductDetailModel? product = _product();

    if (product == null || _notifyLoadingCubit.state.data) return;

    _notifyLoadingCubit.onUpdateData(true);

    final bool success = await _pushService.subscribeToAvailability(
      sku: product.sku,
      productName: _title(),
      imagePath: _imagePath(),
      notificationTitle: LocaleKeys.notificationProductAvailableTitle.tr(),
      notificationBody: LocaleKeys.notificationProductAvailableBody.tr(),
    );

    if (_notifyLoadingCubit.isClosed) return;

    _notifyLoadingCubit.onUpdateData(false);
    _notifySubscribedCubit.onUpdateData(success);

    if (success) {
      _alertService.showSuccess(LocaleKeys.productDetailsNotifyMeSuccess.tr());
      return;
    }

    _alertService.showError(LocaleKeys.productDetailsNotifyMeFailed.tr());
  }

  void _resetGallery() {
    _selectedImageCubit.onUpdateData(0);

    if (_imagePageController.hasClients) _imagePageController.jumpToPage(0);

    if (_thumbnailsController.hasClients) _thumbnailsController.jumpTo(0);
  }

  Future<void> _refresh() => _getProductDetails(_sku());

  Future<void> _retry() => _refresh();

  Future<void> _getBrandProducts(ProductDetailModel? product) async {
    if (product == null) return;

    final String brandId = product.brandId;

    if (brandId.isEmpty) return;

    _brandProductsLoadingCubit.onUpdateData(true);

    try {
      final ProductsByBrandRequest request = ProductsByBrandRequest(
        brandId: brandId,
        pageSize: _brandProductsPageSize,
      );

      final Map<String, dynamic> data = await _graphqlService.query(
        GraphQLDocuments.productsByBrand,
        variables: request.toVariables(),
      );

      if (_brandProductsCubit.isClosed) return;

      final ListRelatedProducts items = ProductsByBrandResponse.fromJson(
        data,
      ).items.where((item) => item.sku != product.sku).toList();

      _brandProductsCubit.onUpdateData(items);
      _brandProductsLoadingCubit.onUpdateData(false);
    } catch (_) {
      if (_brandProductsLoadingCubit.isClosed) return;

      _brandProductsLoadingCubit.onUpdateData(false);
    }
  }

  Future<ProductDetailModel?> _fetchProductDetails(String sku) async {
    final ProductDetailRequest request = ProductDetailRequest(sku: sku);

    final Map<String, dynamic> data = await _graphqlService.query(
      GraphQLDocuments.getProductDetail,
      variables: request.toVariables(),
    );

    return GetProductDetailResponse.fromJson(data).product;
  }

  Future<void> _getProductDetails(String sku) async {
    if (sku.trim().isEmpty) return;

    try {
      final ProductDetailModel? product = await _fetchProductDetails(sku);

      if (_productCubit.isClosed) return;

      _errorMessage = '';

      _quantityCubit.onUpdateData(1);
      _brandProductsCubit.onUpdateData(const []);

      _resetGallery();

      _productCubit.onUpdateData(product);

      unawaited(_getBrandProducts(product));
    } catch (error) {
      _handleFetchError(error);
    }
  }

  void _handleFetchError(Object error) {
    if (_productCubit.isClosed) return;

    final String message = errorMessageFrom(error);

    final ProductDetailModel? product = _product();

    if (product != null) {
      _alertService.showError(message);

      _productCubit.onUpdateData(product);

      return;
    }

    _errorMessage = message;

    _productCubit.onUpdateData(null);
  }
}
