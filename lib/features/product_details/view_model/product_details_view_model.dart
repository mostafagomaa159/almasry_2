part of '../product_details_imports.dart';

class ProductDetailsViewModel {
  final GraphQLService _graphql = sl<GraphQLService>();
  final NavigationService _nav = sl<NavigationService>();
  final FavoritesService _favorites = sl<FavoritesService>();
  final PushNotificationService _push = sl<PushNotificationService>();
  final AlertService _alert = sl<AlertService>();

  static const int _brandProductsPageSize = 10;

  final GenericCubit<ProductDetailsData> _productDetailsCubit =
      GenericCubit<ProductDetailsData>(const ProductDetailsData());

  ProductDetailsArgs? _args;

  final PageController _galleryController = PageController();
  final ScrollController _thumbnailsController = ScrollController();

  static const double _thumbnailExtent = 84;

  ProductDetailsData get _data => _productDetailsCubit.state.data;

  ProductDetailModel? get _product => _data.product;

  GenericCubit<FavoritesModel> get _favoritesCubit => _favorites.favoritesCubit;

  Future<void> _init({required ProductDetailsArgs args}) async {
    _args = args;

    await _favorites.loadFavorites();
    await _getProductDetails(args.sku);
    await _loadNotifySubscription(args.sku);
  }

  void _dispose() {
    _galleryController.dispose();
    _thumbnailsController.dispose();
    _productDetailsCubit.close();
  }

  void _back() {
    _nav.pop();
  }

  void _incrementQuantity() {
    _productDetailsCubit.onUpdateData(
      _data.copyWith(quantity: _data.quantity + 1),
    );
  }

  void _decrementQuantity() {
    if (_data.quantity <= 1) return;

    _productDetailsCubit.onUpdateData(
      _data.copyWith(quantity: _data.quantity - 1),
    );
  }

  void _toggleDescription() {
    _productDetailsCubit.onUpdateData(
      _data.copyWith(isDescriptionExpanded: !_data.isDescriptionExpanded),
    );
  }

  void _selectImage(int index) {
    if (index == _data.selectedImageIndex) return;

    _productDetailsCubit.onUpdateData(
      _data.copyWith(selectedImageIndex: index),
    );

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
    _nav.pushNamed(
      RouteNames.homeComingSoon,
      extra: LocaleKeys.productDetailsAddReview.tr(),
    );
  }

  void _openRelatedProduct(ProductRelatedItemModel item) {
    if (item.sku.trim().isEmpty) return;

    _nav.pushNamed(
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

    await _favorites.toggleFavorite(
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

    return _data.selectedImageIndex.clamp(0, count - 1);
  }

  String _formatPrice(double? price) {
    if (price == null || price <= 0) return '';

    return '${LocaleKeys.currencyShort.tr()} ${price.toStringAsFixed(2)}';
  }

  Future<void> _loadNotifySubscription(String sku) async {
    final bool isSubscribed = await _push.isSubscribed(sku);

    if (!isSubscribed || _productDetailsCubit.isClosed) return;

    _productDetailsCubit.onUpdateData(_data.copyWith(isNotifySubscribed: true));
  }

  Future<void> _notifyWhenAvailable() async {
    final ProductDetailModel? product = _product;

    if (product == null || _data.isNotifyLoading) return;

    _productDetailsCubit.onUpdateData(_data.copyWith(isNotifyLoading: true));

    final bool success = await _push.subscribeToAvailability(
      sku: product.sku,
      productName: _title,
      imagePath: _imagePath,
      notificationTitle: LocaleKeys.notificationProductAvailableTitle.tr(),
      notificationBody: LocaleKeys.notificationProductAvailableBody.tr(),
    );

    if (_productDetailsCubit.isClosed) return;

    _productDetailsCubit.onUpdateData(
      _data.copyWith(isNotifyLoading: false, isNotifySubscribed: success),
    );

    if (success) {
      _alert.showSuccess(LocaleKeys.productDetailsNotifyMeSuccess.tr());
      return;
    }

    _alert.showError(LocaleKeys.productDetailsNotifyMeFailed.tr());
  }

  Future<void> _refresh() => _getProductDetails(_sku);

  Future<void> _retry() => _refresh();

  Future<void> _getBrandProducts(ProductDetailModel? product) async {
    if (product == null) return;

    final String brandId = product.brandId;

    if (brandId.isEmpty) return;

    _productDetailsCubit.onUpdateData(
      _data.copyWith(isBrandProductsLoading: true),
    );

    try {
      final ProductsByBrandRequest request = ProductsByBrandRequest(
        brandId: brandId,
        pageSize: _brandProductsPageSize,
      );

      final Map<String, dynamic> data = await _graphql.query(
        GraphQLDocuments.productsByBrand,
        variables: request.toVariables(),
      );

      if (_productDetailsCubit.isClosed) return;

      final List<ProductRelatedItemModel> items =
          ProductsByBrandResponse.fromJson(
            data,
          ).items.where((item) => item.sku != product.sku).toList();

      _productDetailsCubit.onUpdateData(
        _data.copyWith(brandProducts: items, isBrandProductsLoading: false),
      );
    } catch (_) {
      if (_productDetailsCubit.isClosed) return;

      _productDetailsCubit.onUpdateData(
        _data.copyWith(isBrandProductsLoading: false),
      );
    }
  }

  Future<ProductDetailModel?> _fetchProductDetails(String sku) async {
    final ProductDetailRequest request = ProductDetailRequest(sku: sku);

    final Map<String, dynamic> data = await _graphql.query(
      GraphQLDocuments.getProductDetail,
      variables: request.toVariables(),
    );

    return GetProductDetailResponse.fromJson(data).product;
  }

  Future<void> _getProductDetails(String sku) async {
    if (sku.trim().isEmpty) return;

    _productDetailsCubit.onUpdateData(
      _data.copyWith(
        status: ProductDetailsStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final ProductDetailModel? product = await _fetchProductDetails(sku);

      if (_productDetailsCubit.isClosed) return;

      _productDetailsCubit.onUpdateData(
        _data.copyWith(
          status: ProductDetailsStatus.success,
          product: product,

          quantity: 1,
          selectedImageIndex: 0,
          clearProduct: product == null,
          clearErrorMessage: true,

          brandProducts: const [],
        ),
      );

      _resetGalleryPage();

      unawaited(_getBrandProducts(product));
    } catch (error) {
      if (_productDetailsCubit.isClosed) return;

      _productDetailsCubit.onUpdateData(
        _data.copyWith(
          status: ProductDetailsStatus.error,
          errorMessage: errorMessageFrom(error),
        ),
      );
    }
  }
}
