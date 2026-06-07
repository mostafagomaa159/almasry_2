
import 'package:almasry_2/core/models/response/response_favorite_product.dart';
import 'package:almasry_2/core/services/favorites_db_helper.dart';

class FavoritesRepository {
  FavoritesRepository._();

  static final FavoritesRepository instance = FavoritesRepository._();

  Future<bool> isFavorite(String productId) {
    return FavoritesDbHelper.instance.isFavorite(productId);
  }

  Future<void> addFavorite(FavoriteProductModel product) {
    return FavoritesDbHelper.instance.addFavorite(product);
  }

  Future<void> removeFavorite(String productId) {
    return FavoritesDbHelper.instance.removeFavorite(productId);
  }

  Future<void> toggleFavorite(FavoriteProductModel product) {
    return FavoritesDbHelper.instance.toggleFavorite(product);
  }

  Future<List<FavoriteProductModel>> getFavorites() {
    return FavoritesDbHelper.instance.getFavorites();
  }
}
