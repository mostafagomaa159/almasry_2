part of '../product_search_imports.dart';

/// Back chevron, the search box, and the image-search button — the row that
/// replaces the usual header on this screen.
class ProductSearchAppBar extends StatelessWidget {
  final ProductSearchViewModel vm;

  const ProductSearchAppBar({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      /// Directional, not LTRB: the back chevron leads and the image-search
      /// button trails, so the tight padding has to stay with the chevron when
      /// the locale flips.
      padding: EdgeInsetsDirectional.fromSTEB(6.w, 8.h, 14.w, 0),
      child: Row(
        children: [
          CustomAppBackButton(onTap: vm._back),

          6.horizontalSpace,

          Expanded(
            /// The clear button follows the text in the box, not the query the
            /// results belong to — that one only catches up after the debounce.
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: vm._searchController,
              builder: (context, value, child) {
                return CustomAppSearchField(
                  controller: vm._searchController,
                  focusNode: vm._searchFocusNode,
                  hintText: LocaleKeys.productSearchHint.tr(),
                  onChanged: vm._onQueryChanged,
                  onSubmitted: vm._onQuerySubmitted,
                  onClear: vm._onClearQuery,
                  showClear: value.text.isNotEmpty,
                  autofocus: true,
                );
              },
            ),
          ),

          10.horizontalSpace,

          CustomAppIconButton(
            icon: Icons.image_search_outlined,
            onTap: vm._openImageSearch,
            iconSize: 26,
            backgroundColor: AppColors.darkBlue,
            iconColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}
