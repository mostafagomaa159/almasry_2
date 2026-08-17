part of '../product_search_imports.dart';

/// The "Available only" stock filter. Off it is a plain outlined pill; on it
/// turns red and grows the circular clear badge that switches it back off.
class ProductSearchAvailableChip extends StatelessWidget {
  final ProductSearchViewModel vm;
  final bool isSelected;

  const ProductSearchAvailableChip({
    super.key,
    required this.vm,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: CustomAppChoiceChip(
        label: LocaleKeys.productSearchAvailableOnly.tr(),
        isSelected: isSelected,
        onTap: vm._toggleAvailableOnly,
      ),
    );
  }
}
