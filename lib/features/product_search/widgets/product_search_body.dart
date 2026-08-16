part of '../product_search_imports.dart';

/// Switches between the recent searches and the results: an untouched or
/// too-short query shows the former, anything else the stock filter and list.
class ProductSearchBody extends StatelessWidget {
  final ProductSearchViewModel vm;

  const ProductSearchBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<ProductSearchData>,
      GenericState<ProductSearchData>
    >(
      bloc: vm._searchCubit,
      builder: (context, state) {
        final ProductSearchData data = state.data;

        if (data.status == ProductSearchStatus.idle) {
          return ProductSearchRecentSearches(vm: vm);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ProductSearchAvailableChip(
                vm: vm,
                isSelected: data.availableOnly,
              ),
            ),

            12.verticalSpace,

            Expanded(
              child: ProductSearchList(vm: vm, data: data),
            ),
          ],
        );
      },
    );
  }
}
