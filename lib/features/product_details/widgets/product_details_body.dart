part of '../product_details_imports.dart';

class ProductDetailsBody extends StatelessWidget {
  final ProductDetailsViewModel vm;

  const ProductDetailsBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      body: SafeArea(
        child: Column(
          children: [
            ProductDetailsHeader(
              title: LocaleKeys.productDetailsTitle.tr(),
              onBack: vm._back,
            ),

            Expanded(
              child:
                  BlocBuilder<
                    GenericCubit<ProductDetailModel?>,
                    GenericState<ProductDetailModel?>
                  >(
                    bloc: vm._productCubit,
                    builder: (context, state) {
                      if (state is! GenericUpdateState) {
                        return const ProductDetailsShimmer();
                      }

                      return CustomAppRefreshIndicator(
                        onRefresh: vm._refresh,
                        child: state.data == null
                            ? _ProductDetailsPlaceholder(vm: vm)
                            : _ProductDetailsContent(
                                vm: vm,
                                product: state.data!,
                              ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailsPlaceholder extends StatelessWidget {
  const _ProductDetailsPlaceholder({required this.vm});

  final ProductDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
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
              duration: const Duration(milliseconds: 250),
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
