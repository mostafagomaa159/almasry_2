import 'package:almasry_2/core/database/favorite_product_model.dart';
import 'package:almasry_2/features/wishlist/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almasry_2/core/database/favorites_repository.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<List<FavoriteProductModel>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favoritesFuture = FavoritesRepository.instance.getFavorites();

  }

  void _refreshFavorites() {
    setState(() {
      _loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<FavoriteProductModel>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Something went wrong:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return const WishlistEmptyView();
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];

              return WishlistItemCard(
                product: product,
                onRemoved: _refreshFavorites,
              );
            },
          );
        },
      ),
    );
  }
}
