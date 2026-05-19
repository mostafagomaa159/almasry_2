part of '../home_imports.dart';

class HomeDynamicBlockSection extends StatefulWidget {
  final String title;
  final bool isArabic;
  final HomeMobileBlockResponse block;
  final List<ProductResponse> products;
  final List<HomeSubCategoryResponse>? overrideSubCategories;

  const HomeDynamicBlockSection({
    super.key,
    required this.title,
    required this.isArabic,
    required this.block,
    required this.products,
    this.overrideSubCategories,
  });

  @override
  State<HomeDynamicBlockSection> createState() =>
      _HomeDynamicBlockSectionState();
}

class _HomeDynamicBlockSectionState extends State<HomeDynamicBlockSection> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final subCategories =
        widget.overrideSubCategories ?? widget.block.subCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeSectionHeader(title: widget.title),
        SizedBox(height: 12.h),

        if (subCategories.isNotEmpty) ...[
          SizedBox(
            height: 42.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              reverse: widget.isArabic,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              itemCount: subCategories.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final item = subCategories[index];
                final isSelected = index == selectedIndex;

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryRed.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryRed
                            : const Color(0xFFE6E6E6),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primaryRed
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],

        HomeProductsSection(
          isArabic: widget.isArabic,
          products: widget.products,
        ),
      ],
    );
  }
}
