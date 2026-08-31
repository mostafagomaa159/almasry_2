import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/models/response/favorite/favorite_product_model.dart';
import 'package:almasry_2/core/services/db_services.dart';

class FavoritesService {
  final _dbService = sl<DbServices>();

  final GenericCubit<ListFavorites> favoritesCubit =
      GenericCubit<ListFavorites>(const []);

  final GenericCubit<bool> loadingCubit = GenericCubit<bool>(false);

  ListFavorites get favorites => favoritesCubit.state.data;

  bool isFavorite(String productId) {
    return favorites.any((FavoriteProductModel item) => item.id == productId);
  }

  Future<void> loadFavorites() async {
    loadingCubit.onUpdateData(true);

    final ListFavorites stored = await _dbService.getFavorites();

    favoritesCubit.onUpdateData(stored);

    loadingCubit.onUpdateData(false);
  }

  Future<void> toggleFavorite(FavoriteProductModel product) async {
    await _dbService.toggleFavorite(product);

    await loadFavorites();
  }

  Future<void> removeFavorite(String productId) async {
    await _dbService.removeFavorite(productId);

    await loadFavorites();
  }

  void dispose() {
    favoritesCubit.close();
    loadingCubit.close();
  }
}
