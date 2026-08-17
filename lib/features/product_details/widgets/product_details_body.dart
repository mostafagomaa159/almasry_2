part of '../product_details_imports.dart';

class ProductDetailsBody extends StatelessWidget {
  final ProductDetailsViewModel vm;

  const ProductDetailsBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<ProductDetailModel?>,
      GenericState<ProductDetailModel?>
    >(
      bloc: vm._productCubit,
      builder: (context, state) {
        return CustomAppRefreshIndicator(
          onRefresh: vm._refresh,
          child: _content(state),
        );
      },
    );
  }

  Widget _content(GenericState<ProductDetailModel?> state) {
    if (state is! GenericUpdateState) return const ProductDetailsShimmer();

    final ProductDetailModel? product = state.data;

    if (product == null) return _ProductDetailsPlaceholder(vm: vm);

    return _ProductDetailsContent(vm: vm, product: product);
  }
}

/// Nothing to show: the skeleton while a retry is in flight, the error once it
/// fails, and the not-found box when the SKU simply matched nothing. Both
/// boxes still have to scroll or [CustomAppRefreshIndicator] would have
/// nothing to pull on.
class _ProductDetailsPlaceholder extends StatelessWidget {
  const _ProductDetailsPlaceholder({required this.vm});

  final ProductDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._loadingCubit,
      builder: (context, state) {
        if (state.data) return const ProductDetailsShimmer();

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: vm._errorMessage.isNotEmpty
                    ? CustomAppErrorView(
                        message: vm._errorMessage,
                        onRetry: vm._retry,
                      )
                    : CustomAppEmptyView(
                        message: LocaleKeys.productDetailsNotFound.tr(),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  const _ProductDetailsContent({required this.vm, required this.product});

  final ProductDetailsViewModel vm;
  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: EdgeInsets.only(bottom: 140.h),
            child: FadeInUp(
              duration: AppDurations.contentFade,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductDetailsImageSection(vm: vm, product: product),

                  12.verticalSpace,

                  ProductDetailsSummarySection(vm: vm, product: product),

                  10.verticalSpace,

                  ProductDetailsInfoSection(product: product),

                  10.verticalSpace,

                  ProductDetailsDescriptionSection(vm: vm, product: product),

                  10.verticalSpace,

                  ProductDetailsRelatedSection(vm: vm, product: product),

                  10.verticalSpace,

                  ProductDetailsRatingSection(vm: vm, product: product),

                  24.verticalSpace,
                ],
              ),
            ),
          ),
        ),

        PositionedDirectional(
          start: 16.w,
          end: 16.w,
          bottom: 16.h,
          child: ProductDetailsBottomAction(vm: vm, product: product),
        ),
      ],
    );
  }
}
