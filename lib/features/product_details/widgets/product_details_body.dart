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
          return const Scaffold(body: AppLoadingView());
        }

        if (data.errorMessage != null && data.product == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F7F7),
            body: AppErrorView(message: data.errorMessage!),
          );
        }

        final product = data.product;

        if (product == null) {
          return Scaffold(
            body: AppEmptyView(message: LocaleKeys.productDetailsNotFound.tr()),
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
                          12.verticalSpace,
                          ProductDetailsSummarySection(
                            sku: product.sku,
                            brand: vm._brandFor(product),
                            title: vm._titleFor(product),
                            price: vm._priceFor(product),
                            oldPrice: vm._oldPrice,
                            isInStock: product.isInStock,
                          ),
                          10.verticalSpace,
                          ProductDetailsInfoSection(product: product),
                          10.verticalSpace,
                          ProductDetailsDescriptionSection(
                            description: vm._descriptionFor(product),
                          ),
                          10.verticalSpace,
                          ProductDetailsRatingSection(rating: vm._rating),
                          24.verticalSpace,
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
