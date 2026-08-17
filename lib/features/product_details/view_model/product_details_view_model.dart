part of '../product_details_imports.dart';

typedef ListRelatedProducts = List<ProductRelatedItemModel>;

class ProductDetailsViewModel {
  final _graphqlService = sl<GraphQLService>();
  final _navService = sl<NavigationService>();
  final _favoritesService = sl<FavoritesService>();
  final _pushService = sl<PushNotificationService>();
  final _alertService = sl<AlertService>();

  final GenericCubit<ProductDetailModel?> _productCubit =
      GenericCubit<ProductDetailModel?>(null);
  final GenericCubit<ListRelatedProducts> _brandProductsCubit =
      GenericCubit<ListRelatedProducts>([]);
  final GenericCubit<int> _quantityCubit = GenericCubit<int>(1);
  final GenericCubit<int> _selectedImageCubit = GenericCubit<int>(0);
  final GenericCubit<bool> _loadingCubit = GenericCubit<bool>(false);
  final GenericCubit<bool> _brandProductsLoadingCubit = GenericCubit<bool>(
    false,
  );
  final GenericCubit<bool> _descriptionExpandedCubit = GenericCubit<bool>(
    false,
  );
  final GenericCubit<bool> _notifySubscribedCubit = GenericCubit<bool>(false);
  final GenericCubit<bool> _notifyLoadingCubit = GenericCubit<bool>(false);

  final PageController _galleryController = PageController();
  final ScrollController _thumbnailsController = ScrollController();

  static const int _brandProductsPageSize = 10;
  static const double _thumbnailExtent = 84;

  ProductDetailsArgs? _args;

  bool _isFetching = false;

  String _errorMessage = '';

  ProductDetailModel? get _product => _productCubit.state.data;

  int get _quantity => _quantityCubit.state.data;

  GenericCubit<FavoritesModel> get _favoritesCubit =>
      _favoritesService.favoritesCubit;

  Future<void> _init({required ProductDetailsArgs args}) async {
    _args = args;

    await _favoritesService.loadFavorites();
    await _productApi(args.sku);
    await _loadNotifySubscription(args.sku);
  }

  void _dispose() {
    _galleryController.dispose();
    _thumbnailsController.dispose();
  }

  void _back() {
    _navService.pop();
  }

  void _incrementQuantity() {
    _quantityCubit.onUpdateData(_quantity + 1);
  }

  void _decrementQuantity() {
    if (_quantity <= 1) return;

    _quantityCubit.onUpdateData(_quantity - 1);
  }

  void _toggleDescription() {
    _descriptionExpandedCubit.onUpdateData(
      !_descriptionExpandedCubit.state.data,
    );
  }

  void _selectImage(int index) {
    if (index == _selectedImageCubit.state.data) return;

    _selectedImageCubit.onUpdateData(index);

    _revealThumbnail(index);
  }

  void _showImage(int index) {
    if (index == _selectedImageIndex) return;

    if (!_galleryController.hasClients) {
      _selectImage(index);
      return;
    }

    _galleryController.animateToPage(
      index,
      duration: AppDurations.page,
      curve: Curves.easeOut,
    );
  }

  void _revealThumbnail(int index) {
    if (!_thumbnailsController.hasClients) return;

    final ScrollPosition position = _thumbnailsController.position;
    final double step = _thumbnailExtent.w;
    final double target =
        (index * step) - ((position.viewportDimension - step) / 2);

    _thumbnailsController.animateTo(
      target.clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: AppDurations.page,
      curve: Curves.easeOut,
    );
  }

  void _resetGalleryPage() {
    if (_galleryController.hasClients) _galleryController.jumpToPage(0);

    if (_thumbnailsController.hasClients) _thumbnailsController.jumpTo(0);
  }

  void _addToBasket() {
    // TODO: wire to the cart endpoint once it exists.
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
    final ProductDetailModel? product = _product;

    if (product == null) return;

    await _favoritesService.toggleFavorite(
      FavoriteProductModel(
        id: product.sku,
        title: product.name,
        imagePath: _imagePath,
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

  String get _title {
    final String name = _product?.name ?? '';

    return name.isNotEmpty ? name : (_args?.title ?? '');
  }

  String get _imagePath {
    final String url = _product?.imageUrl ?? '';

    return url.isNotEmpty ? url : (_args?.imagePath ?? '');
  }

  String get _sku => _product?.sku ?? _args?.sku ?? '';

  List<String> get _galleryImages {
    final List<String> urls = _product?.galleryUrls ?? const [];

    if (urls.isNotEmpty) return urls;

    return _imagePath.isEmpty ? const [] : [_imagePath];
  }

  int get _selectedImageIndex {
    final int count = _galleryImages.length;

    if (count == 0) return 0;

    return _selectedImageCubit.state.data.clamp(0, count - 1);
  }

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
    final ProductDetailModel? product = _product;

    if (product == null || _notifyLoadingCubit.state.data) return;

    _notifyLoadingCubit.onUpdateData(true);

    final bool success = await _pushService.subscribeToAvailability(
      sku: product.sku,
      productName: _title,
      imagePath: _imagePath,
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

  Future<void> _refresh() => _productApi(_sku);

  Future<void> _retry() => _refresh();

  Future<void> _productApi(String sku) async {
    if (sku.trim().isEmpty || _isFetching) return;
    _isFetching = true;

    _loadingCubit.onUpdateData(true);

    try {
      final ProductDetailModel? product = await _fetchProductDetails(sku);

      if (_productCubit.isClosed) return;

      _errorMessage = '';

      _quantityCubit.onUpdateData(1);
      _selectedImageCubit.onUpdateData(0);
      _brandProductsCubit.onUpdateData(const []);
      _productCubit.onUpdateData(product);

      _resetGalleryPage();

      unawaited(_getBrandProducts(product));
    } catch (error) {
      if (_productCubit.isClosed) return;

      _handleFetchError(error);
    } finally {
      _isFetching = false;

      if (!_loadingCubit.isClosed) _loadingCubit.onUpdateData(false);
    }
  }

  void _handleFetchError(Object error) {
    final String message = errorMessageFrom(error);

    if (_product != null) {
      _alertService.showError(message);

      _productCubit.onUpdateData(_product);

      return;
    }

    _errorMessage = message;

    _productCubit.onUpdateData(null);
  }

  Future<ProductDetailModel?> _fetchProductDetails(String sku) async {
    final ProductDetailRequest request = ProductDetailRequest(sku: sku);

    final Map<String, dynamic> data = await _graphqlService.query(
      GraphQLDocuments.getProductDetail,
      variables: request.toVariables(),
    );

    return GetProductDetailResponse.fromJson(data).product;
  }

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
    } catch (_) {
      // The carousel is supplementary — a failure leaves the curated
      // related products in place rather than surfacing an error.
    } finally {
      if (!_brandProductsLoadingCubit.isClosed) {
        _brandProductsLoadingCubit.onUpdateData(false);
      }
    }
  }
}
