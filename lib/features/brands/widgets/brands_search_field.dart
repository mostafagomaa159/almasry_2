part of '../brands_imports.dart';

class BrandsSearchField extends StatelessWidget {
  final BrandsViewModel vm;

  const BrandsSearchField({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AppSearchField(
        controller: vm._searchController,
        hintText: LocaleKeys.brandsSearchHint.tr(),
        onChanged: vm._onSearchChanged,
      ),
    );
  }
}
