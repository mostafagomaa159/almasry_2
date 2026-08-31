part of '../brands_imports.dart';

class BrandsSearchField extends StatelessWidget {
  const BrandsSearchField({super.key, required this.vm});

  final BrandsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
        bloc: vm._clearSearchCubit,
        builder: (context, state) {
          return CustomAppSearchField(
            controller: vm._searchController,
            hintText: LocaleKeys.brandsSearchHint.tr(),
            showClear: state.data,
            onClear: vm._clearSearch,
            onChanged: vm._onSearchChanged,
            onSubmitted: vm._brandsSearch,
          );
        },
      ),
    );
  }
}
