part of '../wishlist_imports.dart';

class WishlistBody extends StatelessWidget {
  final WishlistViewModel vm;

  const WishlistBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<ListFavorites>,
      GenericState<ListFavorites>
    >(
      bloc: vm._favoritesCubit,
      builder: (context, state) {
        final ListFavorites favorites = state.data;

        if (favorites.isEmpty) return _WishlistPlaceholder(vm: vm);

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final FavoriteProductModel product = favorites[index];

            return WishlistItemCard(vm: vm, product: product);
          },
        );
      },
    );
  }
}

class _WishlistPlaceholder extends StatelessWidget {
  const _WishlistPlaceholder({required this.vm});

  final WishlistViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._loadingCubit,
      builder: (context, state) {
        if (state.data) return const CustomAppLoadingView();

        return CustomAppEmptyView(
          message: LocaleKeys.wishlistEmptyTitle.tr(),
          icon: Icons.favorite_border,
          description: LocaleKeys.wishlistEmptyDesc.tr(),
        );
      },
    );
  }
}
