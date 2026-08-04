part of '../wishlist_imports.dart';

class WishlistViewModel {
  /// Services

  final FavoritesService _favorites = sl<FavoritesService>();
  final NavigationService _nav = sl<NavigationService>();

  /// Variables

  GenericCubit<FavoritesModel> get _favoritesCubit => _favorites.favoritesCubit;

  FavoritesModel get _data => _favorites.favoritesCubit.state.data;

  /// Init

  void _init() {
    _favorites.loadFavorites();
  }

  /// Actions

  Future<void> _removeFromWishlist(String productId) async {
    await _favorites.removeFavorite(productId);
  }

  void _openDetails(FavoriteProductModel product) {
    _nav.pushNamed(
      RouteNames.productDetails,
      extra: ProductDetailsArgs(
        sku: product.id,
        imagePath: product.imagePath,
        title: product.title,
      ),
    );
  }
}
