part of '../product_search_imports.dart';

class ProductSearchLabelBadge extends StatelessWidget {
  final ProductSearchLabelModel label;

  const ProductSearchLabelBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    if (label.hasImage) {
      return CustomAppNetworkImage(
        url: label.image,
        height: 26.h,
        fit: BoxFit.contain,
        placeholder: const SizedBox.shrink(),
      );
    }

    return CustomAppBadge(
      label: label.text,
      backgroundColor: label.backgroundColor,
      textColor: label.textColor,
      borderRadius: 8,
      verticalPadding: 4,
      uppercase: true,
      maxLines: 1,
    );
  }
}
