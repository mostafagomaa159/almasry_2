part of '../wishlist_imports.dart';

class WishlistViewModel {
  final _favoritesService = sl<FavoritesService>();
  final _navService = sl<NavigationService>();

  late final GenericCubit<ListFavorites> _favoritesCubit =
      _favoritesService.favoritesCubit;

  late final GenericCubit<bool> _loadingCubit = _favoritesService.loadingCubit;

  void _init() {
    _favoritesService.loadFavorites();
  }

  Future<void> _removeFromWishlist(String productId) async {
    await _favoritesService.removeFavorite(productId);
  }

  void _openDetails(FavoriteProductModel product) {
    _navService.pushNamed(
      RouteNames.productDetails,
      extra: ProductDetailsArgs(
        sku: product.id,
        imagePath: product.imagePath,
        title: product.title,
      ),
    );
  }
}
