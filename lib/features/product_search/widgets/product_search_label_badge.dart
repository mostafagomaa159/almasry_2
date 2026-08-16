part of '../product_search_imports.dart';

/// The merchandising badge over the image ("Global", …). Colours come from the
/// CSS the backend ships with the label; an image label wins over the text one
/// when both are set.
///
/// It is always pinned to the top *start* corner — `product_details_label_position`
/// is authored for the web storefront, where the favourite button isn't sitting
/// in the opposite corner.
class ProductSearchLabelBadge extends StatelessWidget {
  final ProductSearchLabelModel label;

  const ProductSearchLabelBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    if (label.hasImage) {
      return AppNetworkImage(
        url: label.image,
        height: 26.h,
        fit: BoxFit.contain,
        placeholder: const SizedBox.shrink(),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: label.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label.text.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: label.textColor,
        ),
      ),
    );
  }
}
