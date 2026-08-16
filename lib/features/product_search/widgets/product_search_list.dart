part of '../product_search_imports.dart';

/// Everything below the "Available only" chip: the loading skeleton, the error
/// and empty states, and the results grid — all of it under pull-to-refresh.
class ProductSearchList extends StatelessWidget {
  const ProductSearchList({super.key, required this.vm, required this.data});

  final ProductSearchViewModel vm;
  final ProductSearchData data;

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(onRefresh: vm._refresh, child: _content());
  }

  Widget _content() {
    if (data.status == ProductSearchStatus.loading) {
      return const ProductSearchShimmer();
    }

    if (data.status == ProductSearchStatus.error) {
      return _ProductSearchPlaceholder(
        child: AppErrorView(message: data.errorMessage, onRetry: vm._retry),
      );
    }

    if (data.products.isEmpty) {
      return _ProductSearchPlaceholder(
        child: AppEmptyView(
          icon: Icons.search_off_rounded,
          message: LocaleKeys.noProductsFound.tr(),
          description: LocaleKeys.productSearchEmptyDescription.tr(),
        ),
      );
    }

    return _ProductSearchGrid(vm: vm, data: data);
  }
}

/// The error and empty states are centred boxes, but they still have to scroll
/// or [AppRefreshIndicator] would have nothing to pull on.
class _ProductSearchPlaceholder extends StatelessWidget {
  const _ProductSearchPlaceholder({required this.child});

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

class _ProductSearchGrid extends StatelessWidget {
  const _ProductSearchGrid({required this.vm, required this.data});

  final ProductSearchViewModel vm;
  final ProductSearchData data;

  @override
  Widget build(BuildContext context) {
    final List<ProductSearchProductModel> products = data.products;

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
        itemCount: products.length + (data.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= products.length) {
            return Center(
              child: SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primaryRed,
                ),
              ),
            );
          }

          return FadeInUp(
            duration: const Duration(milliseconds: 200),

            delay: Duration(milliseconds: 2 * index),
            child: ProductSearchItem(vm: vm, product: products[index]),
          );
        },
      ),
    );
  }
}
