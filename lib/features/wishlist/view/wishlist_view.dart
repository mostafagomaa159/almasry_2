part of '../../wishlist/wishlist_imports.dart';



class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.favorites.isEmpty) {
            return const WishlistEmptyView();
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final product = state.favorites[index];

              return WishlistItemCard(
                product: product,
              );
            },
          );
        },
      ),
    );
  }
}
