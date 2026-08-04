part of '../wishlist_imports.dart';

class WishlistBody extends StatelessWidget {
  final WishlistViewModel vm;

  const WishlistBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<FavoritesModel>,
      GenericState<FavoritesModel>
    >(
      bloc: vm._favoritesCubit,
      builder: (context, state) {
        final data = vm._data;

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

            return WishlistItemCard(vm: vm, product: product);
          },
        );
      },
    );
  }
}
