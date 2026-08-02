import 'package:almasry_2/core/models/response/favorite/favorite_product_model.dart';

class FavoritesModel {
  final bool isLoading;
  final List<FavoriteProductModel> favorites;

  const FavoritesModel({required this.isLoading, required this.favorites});

  factory FavoritesModel.initial() {
    return const FavoritesModel(isLoading: false, favorites: []);
  }

  FavoritesModel copyWith({
    bool? isLoading,
    List<FavoriteProductModel>? favorites,
  }) {
    return FavoritesModel(
      isLoading: isLoading ?? this.isLoading,
      favorites: favorites ?? this.favorites,
    );
  }

  bool isFavorite(String productId) {
    return favorites.any((item) => item.id == productId);
  }
}
