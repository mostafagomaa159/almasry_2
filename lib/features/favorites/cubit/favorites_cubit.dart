import 'package:almasry_2/core/database/favorite_product_model.dart';
import 'package:almasry_2/core/database/favorites_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesState.initial());

  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true));

    final favorites = await FavoritesRepository.instance.getFavorites();

    emit(
      state.copyWith(
        isLoading: false,
        favorites: favorites,
      ),
    );
  }

  Future<void> toggleFavorite(FavoriteProductModel product) async {
    await FavoritesRepository.instance.toggleFavorite(product);
    await loadFavorites();
  }

  Future<void> removeFavorite(String productId) async {
    await FavoritesRepository.instance.removeFavorite(productId);
    await loadFavorites();
  }

  bool isFavorite(String productId) {
    return state.isFavorite(productId);
  }
}
