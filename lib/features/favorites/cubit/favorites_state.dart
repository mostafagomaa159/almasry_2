import 'package:almasry_2/core/database/favorite_product_model.dart';

class FavoritesState {
  final bool isLoading;
  final List<FavoriteProductModel> favorites;

  const FavoritesState({
    required this.isLoading,
    required this.favorites,
  });

  factory FavoritesState.initial() {
    return const FavoritesState(
      isLoading: false,
      favorites: [],
    );
  }

  FavoritesState copyWith({
    bool? isLoading,
    List<FavoriteProductModel>? favorites,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      favorites: favorites ?? this.favorites,
    );
  }

  bool isFavorite(String productId) {
    return favorites.any((item) => item.id == productId);
  }
}
