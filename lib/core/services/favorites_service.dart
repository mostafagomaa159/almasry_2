import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/models/response/favorite/favorite_product_model.dart';
import 'package:almasry_2/core/models/response/favorite/favorites_model.dart';
import 'package:almasry_2/core/services/db_services.dart';

class FavoritesService {
  final GenericCubit<FavoritesModel> favoritesCubit =
      GenericCubit<FavoritesModel>(FavoritesModel.initial());

  Future<void> loadFavorites() async {
    favoritesCubit.onUpdateData(
      favoritesCubit.state.data.copyWith(isLoading: true),
    );

    final favorites = await DbServices.instance.getFavorites();

    favoritesCubit.onUpdateData(
      favoritesCubit.state.data.copyWith(
        isLoading: false,
        favorites: favorites,
      ),
    );
  }

  Future<void> toggleFavorite(FavoriteProductModel product) async {
    await DbServices.instance.toggleFavorite(product);
    await loadFavorites();
  }

  Future<void> removeFavorite(String productId) async {
    await DbServices.instance.removeFavorite(productId);
    await loadFavorites();
  }

  bool isFavorite(String productId) {
    return favoritesCubit.state.data.isFavorite(productId);
  }

  void dispose() {
    favoritesCubit.close();
  }
}
