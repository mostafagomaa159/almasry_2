part of '../home_imports.dart';

class ProductCard extends StatefulWidget {
  final HomeViewModel vm;
  final String sku;
  final String imagePath;
  final String title;
  final String price;
  final String oldPrice;
  final String category;
  final String description;
  final String discountText;
  final String pointsText;
  final double rating;
  final bool isNetworkImage;

  final bool isInStock;

  const ProductCard({
    super.key,
    required this.vm,
    required this.sku,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.description,
    required this.discountText,
    required this.pointsText,
    required this.rating,
    this.isNetworkImage = false,
    this.isInStock = true,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1;

  Future<void> _toggleFavorite() async {
    final product = FavoriteProductModel(
      id: widget.sku,
      title: widget.title,
      imagePath: widget.imagePath,
      price: widget.price,
      oldPrice: widget.oldPrice,
      category: widget.category,
      description: widget.description,
    );

    await widget.vm._toggleFavorite(product);
  }

  void _incrementQuantity() {
    setState(() => quantity++);
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() => quantity--);
    }
  }

  Future<void> _addToCart() async {
    await widget.vm._addToCart(sku: widget.sku, quantity: quantity);
  }

  void _openProductDetails() {
    widget.vm._openProductDetails(
      sku: widget.sku,
      title: widget.title,
      imagePath: widget.imagePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasOldPrice = widget.oldPrice.trim().isNotEmpty;
    final bool hasDiscount = widget.discountText.trim().isNotEmpty;

    final radius = BorderRadius.circular(16.r);

    return CustomAppCard(
      width: 165.w,
      margin: EdgeInsetsDirectional.only(start: 10.w),
      borderColor: AppColors.borderSoft,
      shadowOpacity: 0.04,
      shadowBlur: 8,
      shadowOffsetY: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              onTap: _openProductDetails,
              borderRadius: radius,
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 130.h,
                            width: double.infinity,
                            child: Center(
                              child: widget.isNetworkImage
                                  ? CustomAppNetworkImage(
                                      url: widget.imagePath,
                                      height: 110.h,
                                      fit: BoxFit.contain,
                                      placeholder: Container(
                                        height: 100.h,
                                        width: 100.w,
                                        color: Colors.grey.shade100,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          color: Colors.grey,
                                          size: 26.sp,
                                        ),
                                      ),
                                    )
                                  : Image.asset(
                                      widget.imagePath,
                                      height: 110.h,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),

                          Align(
                            alignment: AlignmentDirectional.topEnd,
                            child:
                                BlocBuilder<
                                  GenericCubit<ListFavorites>,
                                  GenericState<ListFavorites>
                                >(
                                  builder: (context, state) {
                                    final bool isFavorite = widget
                                        .vm
                                        ._favoritesService
                                        .isFavorite(widget.sku);

                                    return CustomAppFavoriteButton(
                                      isFavorite: isFavorite,
                                      onTap: _toggleFavorite,
                                      roundedOutline: false,
                                      inactiveColor:
                                          AppColors.iconFavoriteInactive,
                                      shadowOpacity: 0.04,
                                    );
                                  },
                                ),
                          ),
                        ],
                      ),
                    ),

                    4.verticalSpace,

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        hasDiscount ? widget.discountText : '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    6.verticalSpace,

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navyCard,
                        ),
                      ),
                    ),

                    8.verticalSpace,

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: CustomAppPriceRow(
                        mainAxisAlignment: MainAxisAlignment.center,
                        price: widget.price,
                        oldPrice: hasOldPrice ? widget.oldPrice : null,
                        priceStyle: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navyCard,
                        ),
                        oldPriceStyle: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.unavailableGrey,
                        ),
                      ),
                    ),

                    10.verticalSpace,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: widget.isInStock ? _actionRow() : _outOfStockBanner(),
          ),

          12.verticalSpace,
        ],
      ),
    );
  }

  Widget _outOfStockBanner() {
    return CustomAppStatusBanner(
      label: LocaleKeys.outOfStock.tr(),
      height: 32,
      fontSize: 13,
    );
  }

  Widget _actionRow() {
    return Row(
      children: [
        BlocBuilder<GenericCubit<Set<String>>, GenericState<Set<String>>>(
          bloc: widget.vm._addingSkusCubit,
          builder: (context, state) {
            final bool isAdding = state.data.contains(widget.sku.trim());

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isAdding ? null : _addToCart,
                borderRadius: BorderRadius.circular(8.r),
                child: SizedBox(
                  width: 28.w,
                  height: 28.h,
                  child: isAdding
                      ? Center(
                          child: SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              color: AppColors.textMuted,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.add_shopping_cart_outlined,
                          size: 19.sp,
                          color: AppColors.textMuted,
                        ),
                ),
              ),
            );
          },
        ),
        const Spacer(),
        CustomAppQuantityStepper(
          quantity: quantity,
          onIncrement: _incrementQuantity,
          onDecrement: quantity > 1 ? _decrementQuantity : null,
          incrementFirst: false,
          boxedButtons: true,
          backgroundColor: AppColors.white,
          borderColor: AppColors.borderStepper,
          borderRadius: 10,
          horizontalPadding: 6,
          buttonSize: 24,
          iconSize: 16,
          spacing: 12,
          fontSize: 14,
          contentColor: AppColors.navyCard,
          iconColor: AppColors.textMuted,
        ),
      ],
    );
  }
}
