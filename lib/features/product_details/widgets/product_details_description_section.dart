part of '../product_details_imports.dart';

class ProductDetailsDescriptionSection extends StatefulWidget {
  final String description;

  const ProductDetailsDescriptionSection({
    super.key,
    required this.description,
  });

  @override
  State<ProductDetailsDescriptionSection> createState() =>
      _ProductDetailsDescriptionSectionState();
}

class _ProductDetailsDescriptionSectionState
    extends State<ProductDetailsDescriptionSection> {
  bool _expanded = false;

  bool get _hasContent {
    final cleaned = widget.description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
    return cleaned.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasContent) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.productDetailsDescription.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF11385B),
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFE6E6E6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.productDetailsDescriptionTitle.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3A3A3A),
                  ),
                ),
                SizedBox(height: 10.h),
                ClipRect(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    child: ConstrainedBox(
                      constraints: _expanded
                          ? const BoxConstraints()
                          : BoxConstraints(maxHeight: 120.h),
                      child: Html(
                        data: widget.description,
                        style: {
                          "html": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(14),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8C8C8C),
                            lineHeight: LineHeight.number(1.7),
                          ),
                          "p": Style(margin: Margins.only(bottom: 10)),
                          "h1": Style(
                            fontSize: FontSize(20),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF11385B),
                          ),
                          "h2": Style(
                            fontSize: FontSize(18),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF11385B),
                          ),
                          "h3": Style(
                            fontSize: FontSize(16),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF11385B),
                          ),
                          "ul": Style(
                            margin: Margins.only(bottom: 10),
                            padding: HtmlPaddings.only(left: 18),
                          ),
                          "ol": Style(
                            margin: Margins.only(bottom: 10),
                            padding: HtmlPaddings.only(left: 18),
                          ),
                          "li": Style(
                            margin: Margins.only(bottom: 6),
                            fontSize: FontSize(14),
                            color: const Color(0xFF8C8C8C),
                            lineHeight: LineHeight.number(1.6),
                          ),
                          "strong": Style(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF11385B),
                          ),
                          "b": Style(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF11385B),
                          ),
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      _expanded
                          ? LocaleKeys.productDetailsShowLess.tr()
                          : LocaleKeys.productDetailsShowMore.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD7262E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
