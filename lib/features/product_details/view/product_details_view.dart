part of '../product_details_imports.dart';


class ProductDetailsView extends StatefulWidget {
  final ProductDetailsArgs args;

  const ProductDetailsView({super.key, required this.args});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late final ProductDetailsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ProductDetailsViewModel()..init(sku: widget.args.sku);
  }

  Future<void> _toggleFavorite(ProductModel product) async {
    final favoriteProduct = FavoriteProductModel(
      id: product.id.toString(),
      title: product.name,
      imagePath: product.imageUrl,
      price: product.price.toString(),
      oldPrice: '',
      category: '',
      description: product.description,
    );

    await sl<FavoritesViewModel>().toggleFavorite(favoriteProduct);
  }

  String _formatPrice(num? price) {
    if (price == null) return '';
    return '${price.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}';
  }

  String _getCustomAttributeValue(ProductModel product, String code) {
    try {
      final attribute = product.customAttributes?.firstWhere(
        (item) => item.attributeCode == code,
      );

      final value = attribute?.value;
      if (value == null) return '';

      if (value is List) {
        return value.join(', ');
      }

      return value.toString().trim();
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return BlocBuilder<
      GenericCubit<ProductDetailsModel>,
      GenericState<ProductDetailsModel>
    >(
      bloc: viewModel.productDetailsCubit,
      builder: (context, state) {
        final data = state.data;

        if (data.isLoading && data.product == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (data.errorMessage != null && data.product == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F7F7),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(data.errorMessage!, textAlign: TextAlign.center),
              ),
            ),
          );
        }

        final product = data.product;

        if (product == null) {
          return const Scaffold(body: Center(child: Text('No product found')));
        }

        final imagePath = product.imageUrl.isNotEmpty
            ? product.imageUrl
            : (widget.args.imagePath ?? '');

        final title = product.name.isNotEmpty
            ? product.name
            : (widget.args.title ?? '');

        final description = product.description ?? '';
        final price = _formatPrice(product.price);

        final brand = _getCustomAttributeValue(product, 'brand');
        final oldPrice = '';
        final rating = 0.0;
        final isInStock = true;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      ProductDetailsHeader(
                        title: 'التفاصيل',
                        isArabic: isArabic,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: 140.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductDetailsImageSection(
                                imagePath: imagePath,
                                product: product,
                                onFavoriteTap: () => _toggleFavorite(product),
                              ),
                              SizedBox(height: 12.h),
                              ProductDetailsSummarySection(
                                sku: product.sku,
                                brand: brand,
                                title: title,
                                price: price,
                                oldPrice: oldPrice,
                                isInStock: isInStock,
                              ),
                              SizedBox(height: 10.h),
                              ProductDetailsInfoSection(product: product),
                              SizedBox(height: 10.h),
                              ProductDetailsDescriptionSection(
                                description: description,
                              ),
                              SizedBox(height: 10.h),
                              ProductDetailsRatingSection(rating: rating),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16.w,
                  left: 16.w,
                  bottom: 16.h,
                  child: ProductDetailsBottomAction(
                    quantity: data.quantity,
                    onIncrementTap: viewModel.incrementQuantity,
                    onDecrementTap: viewModel.decrementQuantity,
                    onAddToBasketTap: () {
                      // TODO
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
