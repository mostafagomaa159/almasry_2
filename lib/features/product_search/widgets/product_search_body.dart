part of '../product_search_imports.dart';

/// Switches between the recent searches and the results: an untouched or
/// too-short query shows the former, anything else the stock filter and list.
class ProductSearchBody extends StatelessWidget {
  final ProductSearchViewModel vm;

  const ProductSearchBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._hasQueryCubit,
      builder: (context, state) {
        if (!state.data) return ProductSearchRecentSearches(vm: vm);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
                bloc: vm._availableOnlyCubit,
                builder: (context, availableState) {
                  return ProductSearchAvailableChip(
                    vm: vm,
                    isSelected: availableState.data,
                  );
                },
              ),
            ),

            12.verticalSpace,

            ProductSearchList(vm: vm),
          ],
        );
      },
    );
  }
}
