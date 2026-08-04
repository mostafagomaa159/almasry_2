part of '../product_details_imports.dart';

class ProductDetailsBody extends StatelessWidget {
  final ProductDetailsViewModel vm;

  const ProductDetailsBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<ProductDetailsModel>,
      GenericState<ProductDetailsModel>
    >(
      bloc: vm._productDetailsCubit,
      builder: (context, state) {
        final data = vm._data;

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
          return Scaffold(
            body: Center(child: Text(LocaleKeys.productDetailsNotFound.tr())),
          );
        }

        return _buildContent(context, product);
      },
    );
  }

  Widget _buildContent(BuildContext context, ProductModel product) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  ProductDetailsHeader(
                    title: LocaleKeys.productDetailsTitle.tr(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 140.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductDetailsImageSection(
                            imagePath: vm._imagePathFor(product),
                            product: product,
                            onFavoriteTap: () => vm._toggleFavorite(product),
                          ),
                          SizedBox(height: 12.h),
                          ProductDetailsSummarySection(
                            sku: product.sku,
                            brand: vm._brandFor(product),
                            title: vm._titleFor(product),
                            price: vm._priceFor(product),
                            oldPrice: vm._oldPrice,
                            isInStock: product.isInStock,
                          ),
                          SizedBox(height: 10.h),
                          ProductDetailsInfoSection(product: product),
                          SizedBox(height: 10.h),
                          ProductDetailsDescriptionSection(
                            description: vm._descriptionFor(product),
                          ),
                          SizedBox(height: 10.h),
                          ProductDetailsRatingSection(rating: vm._rating),
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
              child: ProductDetailsBottomAction(vm: vm),
            ),
          ],
        ),
      ),
    );
  }
}
