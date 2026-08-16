part of '../brands_imports.dart';

class BrandsList extends StatelessWidget {
  const BrandsList({super.key, required this.vm});

  final BrandsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          AppRefreshIndicator(
            onRefresh: vm._refresh,
            child:
                BlocBuilder<GenericCubit<ListBrands>, GenericState<ListBrands>>(
                  bloc: vm._brandsCubit,
                  builder: (context, state) {
                    if (state is! GenericUpdateState) {
                      return const BrandsShimmer();
                    }

                    if (state.data.isEmpty) return _BrandsPlaceholder(vm: vm);

                    return _BrandsGrid(vm: vm, brands: state.data);
                  },
                ),
          ),

          _BrandsSearchOverlay(vm: vm),
        ],
      ),
    );
  }
}

/// The error and empty states. Both are centred boxes, but they still have to
/// scroll or [AppRefreshIndicator] would have nothing to pull on.
class _BrandsPlaceholder extends StatelessWidget {
  const _BrandsPlaceholder({required this.vm});

  final BrandsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: vm._errorMessage.isNotEmpty
                ? AppErrorView(message: vm._errorMessage, onRetry: vm._retry)
                : AppEmptyView(message: LocaleKeys.brandsEmpty.tr()),
          ),
        );
      },
    );
  }
}

class _BrandsGrid extends StatelessWidget {
  const _BrandsGrid({required this.vm, required this.brands});

  final BrandsViewModel vm;
  final ListBrands brands;

  @override
  Widget build(BuildContext context) {
    final bool hasMore = vm._canFetchMoreItems;

    return Scrollbar(
      controller: vm._scrollController,
      child: GridView.builder(
        controller: vm._scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(20.r),
        itemCount: brands.length + (hasMore ? 1 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20.w,
          mainAxisSpacing: 20.h,
        ),
        itemBuilder: (context, index) {
          if (index >= brands.length) return vm._alert.showLoadingView();

          return _BrandGridItem(vm: vm, brand: brands[index], index: index);
        },
      ),
    );
  }
}

class _BrandGridItem extends StatelessWidget {
  const _BrandGridItem({
    required this.vm,
    required this.brand,
    required this.index,
  });

  final BrandsViewModel vm;
  final BrandModel brand;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 200),

      delay: Duration(milliseconds: 2 * index),
      child: GestureDetector(
        onTap: () => vm._brandClickAction(brand),
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFEAEAEA)),
          ),
          child: Center(
            child: brand.hasImage
                ? AppNetworkImage(
                    url: brand.image,
                    fit: BoxFit.contain,
                    placeholder: _BrandNameLabel(name: brand.name),
                  )
                : _BrandNameLabel(name: brand.name),
          ),
        ),
      ),
    );
  }
}

class _BrandNameLabel extends StatelessWidget {
  const _BrandNameLabel({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/// Covers the previous results while a search is in flight, so the grid never
/// looks like it answered the new query with the old brands.
class _BrandsSearchOverlay extends StatelessWidget {
  const _BrandsSearchOverlay({required this.vm});

  final BrandsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._loadingCubit,
      builder: (context, state) {
        if (!state.data) return const SizedBox.shrink();

        return const ColoredBox(
          color: AppColors.white,
          child: SizedBox.expand(child: BrandsShimmer()),
        );
      },
    );
  }
}
