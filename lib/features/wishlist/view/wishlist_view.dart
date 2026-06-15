part of '../../wishlist/wishlist_imports.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  @override
  void initState() {
    super.initState();
    sl<FavoritesViewModel>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
      ),
      body: BlocBuilder<
          GenericCubit<FavoritesModel>,
          GenericState<FavoritesModel>>(
        builder: (context, state) {
          final data = state.data;

          if (data.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (data.favorites.isEmpty) {
            return const WishlistEmptyView();
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: data.favorites.length,
            itemBuilder: (context, index) {
              final product = data.favorites[index];

              return WishlistItemCard(product: product);
            },
          );
        },
      ),
    );
  }
}
