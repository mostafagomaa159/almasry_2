part of '../product_details_imports.dart';

/// The "Details" card: the short description always, the full one revealed by
/// "Show more". Expansion is ViewModel state, so it survives a rebuild.
class ProductDetailsDescriptionSection extends StatelessWidget {
  final ProductDetailsViewModel vm;
  final ProductDetailModel product;

  const ProductDetailsDescriptionSection({
    super.key,
    required this.vm,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final String shortDescription = product.shortDescriptionHtml;
    final String fullDescription = product.descriptionHtml;

    final bool hasShort = _hasContent(shortDescription);
    final bool hasFull = _hasContent(fullDescription);

    if (!hasShort && !hasFull) return const SizedBox.shrink();

    final bool isExpanded = vm._data.isDescriptionExpanded;

    final String body = hasShort ? shortDescription : fullDescription;

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
              color: AppColors.navyHeading,
            ),
          ),

          14.verticalSpace,

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.borderButton),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.productDetailsDescriptionTitle.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBody,
                  ),
                ),

                10.verticalSpace,

                ClipRect(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    child: ConstrainedBox(
                      constraints: isExpanded
                          ? const BoxConstraints()
                          : BoxConstraints(maxHeight: 120.h),
                      child: _DescriptionHtml(data: body),
                    ),
                  ),
                ),

                if (isExpanded && hasShort && hasFull) ...[
                  14.verticalSpace,
                  const Divider(height: 1, color: AppColors.borderButton),
                  14.verticalSpace,
                  Text(
                    LocaleKeys.productDetailsFullDescription.tr(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBody,
                    ),
                  ),
                  10.verticalSpace,
                  _DescriptionHtml(data: fullDescription),
                ],

                10.verticalSpace,

                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: GestureDetector(
                    onTap: vm._toggleDescription,
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      isExpanded
                          ? LocaleKeys.productDetailsShowLess.tr()
                          : LocaleKeys.productDetailsShowMore.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.redHeading,
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

  static bool _hasContent(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim()
        .isNotEmpty;
  }
}

class _DescriptionHtml extends StatelessWidget {
  const _DescriptionHtml({required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      style: {
        'html': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(14),
          fontWeight: FontWeight.w500,
          color: AppColors.textCaption,
          lineHeight: LineHeight.number(1.7),
        ),
        'p': Style(margin: Margins.only(bottom: 10)),
        'h1': Style(
          fontSize: FontSize(20),
          fontWeight: FontWeight.w700,
          color: AppColors.navyHeading,
        ),
        'h2': Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.w700,
          color: AppColors.navyHeading,
        ),
        'h3': Style(
          fontSize: FontSize(16),
          fontWeight: FontWeight.w700,
          color: AppColors.navyHeading,
        ),
        'ul': Style(
          margin: Margins.only(bottom: 10),
          padding: HtmlPaddings.only(left: 18),
        ),
        'ol': Style(
          margin: Margins.only(bottom: 10),
          padding: HtmlPaddings.only(left: 18),
        ),
        'li': Style(
          margin: Margins.only(bottom: 6),
          fontSize: FontSize(14),
          color: AppColors.textCaption,
          lineHeight: LineHeight.number(1.6),
        ),
        'strong': Style(
          fontWeight: FontWeight.w700,
          color: AppColors.navyHeading,
        ),
        'b': Style(fontWeight: FontWeight.w700, color: AppColors.navyHeading),
      },
    );
  }
}
