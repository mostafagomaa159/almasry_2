part of '../product_details_imports.dart';



class ProductDetailsView extends StatefulWidget {
  final ProductDetailsArgs args;

  const ProductDetailsView({
    super.key,
    required this.args,
  });

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  Future<void> _toggleFavorite() async {
    final product = FavoriteProductModel(
      id: widget.args.productId,
      title: widget.args.title,
      imagePath: widget.args.imagePath,
      price: widget.args.price,
      oldPrice: widget.args.oldPrice,
      category: widget.args.category,
      description: widget.args.description,
    );

    await context.read<FavoritesCubit>().toggleFavorite(product);
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => ProductDetailsCubit(),
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F7F7),
            body: SafeArea(
              child: Column(
                children: [
                  ProductDetailsHeader(
                    title: widget.args.title,
                    isArabic: isArabic,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ProductDetailsImageSection(
                                imagePath: widget.args.imagePath,
                              ),
                              Positioned(
                                top: 16.h,
                                right: 20.w,
                                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                                  builder: (context, favoritesState) {
                                    final isFavorite = favoritesState.isFavorite(widget.args.productId);

                                    return InkWell(
                                      onTap: _toggleFavorite,
                                      borderRadius: BorderRadius.circular(50.r),
                                      child: Container(
                                        width: 42.w,
                                        height: 42.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          isFavorite ? Icons.favorite : Icons.favorite_border,
                                          color: isFavorite ? Colors.red : Colors.grey,
                                          size: 22.sp,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 18.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.args.title,
                                  style: TextStyle(
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF11385B),
                                    height: 1.35,
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                Text(
                                  widget.args.price,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2C2C2C),
                                  ),
                                ),
                                SizedBox(height: 28.h),
                                Text(
                                  LocaleKeys.productDetailsCategories.tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2C2C2C),
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                ProductDetailsCategoryChip(
                                  title: widget.args.category,
                                ),
                                SizedBox(height: 36.h),
                                ProductDetailsDescriptionSection(
                                  description: widget.args.description,
                                ),
                                SizedBox(height: 34.h),
                                ProductDetailsRatingSection(
                                  rating: widget.args.rating,
                                ),
                                SizedBox(height: 34.h),
                                ProductDetailsBottomAction(
                                  quantity: state.quantity,
                                  onIncrementTap: () {
                                    context
                                        .read<ProductDetailsCubit>()
                                        .incrementQuantity();
                                  },
                                  onDecrementTap: () {
                                    context
                                        .read<ProductDetailsCubit>()
                                        .decrementQuantity();
                                  },
                                  onAddToBasketTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
