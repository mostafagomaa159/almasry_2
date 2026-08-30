part of '../product_search_imports.dart';

/// Everything below the "Available only" chip: the first-load skeleton, the
/// error and empty states, and the results grid — all of it under
/// pull-to-refresh, with a shimmer covering the previous results while a new
/// query is in flight.
class ProductSearchList extends StatelessWidget {
  const ProductSearchList({super.key, required this.vm});

  final ProductSearchViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          CustomAppRefreshIndicator(
            onRefresh: vm._refresh,
            child:
                BlocBuilder<
                  GenericCubit<ListSearchProducts>,
                  GenericState<ListSearchProducts>
                >(
                  bloc: vm._productsCubit,
                  builder: (context, state) {
                    if (state is! GenericUpdateState) {
                      return const ProductSearchShimmer();
                    }

                    if (state.data.isEmpty) {
                      return _ProductSearchPlaceholder(vm: vm);
                    }

                    return _ProductSearchGrid(vm: vm, products: state.data);
                  },
                ),
          ),

          _ProductSearchOverlay(vm: vm),
        ],
      ),
    );
  }
}

/// The error and empty states. Both are centred boxes, but they still have to
/// scroll or [CustomAppRefreshIndicator] would have nothing to pull on.
class _ProductSearchPlaceholder extends StatelessWidget {
  const _ProductSearchPlaceholder({required this.vm});

  final ProductSearchViewModel vm;

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
                    icon: Icons.search_off_rounded,
                    message: LocaleKeys.noProductsFound.tr(),
                    description: LocaleKeys.productSearchEmptyDescription.tr(),
                  ),
          ),
        );
      },
    );
  }
}

class _ProductSearchGrid extends StatelessWidget {
  const _ProductSearchGrid({required this.vm, required this.products});

  final ProductSearchViewModel vm;
  final ListSearchProducts products;

  @override
  Widget build(BuildContext context) {
    final bool hasMore = vm._canFetchMoreItems();

    return Scrollbar(
      controller: vm._scrollController,
      child: GridView.builder(
        controller: vm._scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.56,
        ),
        itemCount: products.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= products.length) {
            return vm._alertService.showLoadingView();
          }

          return FadeInUp(
            duration: AppDurations.listStagger,
            delay: Duration(milliseconds: 2 * index),
            child: ProductSearchItem(vm: vm, product: products[index]),
          );
        },
      ),
    );
  }
}

/// Covers the previous results while a search is in flight, so the grid never
/// looks like it answered the new query with the old products.
class _ProductSearchOverlay extends StatelessWidget {
  const _ProductSearchOverlay({required this.vm});

  final ProductSearchViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._loadingCubit,
      builder: (context, state) {
        if (!state.data) return const SizedBox.shrink();

        return const ColoredBox(
          color: AppColors.white,
          child: SizedBox.expand(child: ProductSearchShimmer()),
        );
      },
    );
  }
}
