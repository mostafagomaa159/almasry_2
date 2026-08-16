part of '../product_details_imports.dart';

class ProductDetailsBody extends StatelessWidget {
  final ProductDetailsViewModel vm;

  const ProductDetailsBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
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
                    GenericCubit<ProductDetailsData>,
                    GenericState<ProductDetailsData>
                  >(
                    bloc: vm._productDetailsCubit,
                    builder: (context, state) {
                      return AppRefreshIndicator(
                        onRefresh: vm._refresh,
                        child: _content(state.data),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(ProductDetailsData data) {
    if (data.product == null) {
      if (data.status == ProductDetailsStatus.initial ||
          data.status == ProductDetailsStatus.loading) {
        return const ProductDetailsShimmer();
      }

      if (data.status == ProductDetailsStatus.error) {
        return _ProductDetailsPlaceholder(
          child: AppErrorView(message: data.errorMessage, onRetry: vm._retry),
        );
      }

      return _ProductDetailsPlaceholder(
        child: AppEmptyView(message: LocaleKeys.productDetailsNotFound.tr()),
      );
    }

    return _ProductDetailsContent(vm: vm, data: data);
  }
}

/// The error and empty states are centred boxes, but they still have to scroll
/// or [AppRefreshIndicator] would have nothing to pull on.
class _ProductDetailsPlaceholder extends StatelessWidget {
  const _ProductDetailsPlaceholder({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        );
      },
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  const _ProductDetailsContent({required this.vm, required this.data});

  final ProductDetailsViewModel vm;
  final ProductDetailsData data;

  @override
  Widget build(BuildContext context) {
    final ProductDetailModel product = data.product!;

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
