part of '../categories_imports.dart';

class CategoriesChildrenSection extends StatelessWidget {
  final CategoriesViewModel vm;

  const CategoriesChildrenSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final parentCategory = vm._selectedParentCategory;

    if (parentCategory == null) {
      return Center(child: Text(LocaleKeys.categoriesNoSelection.tr()));
    }

    final childrenCategories = vm._filteredChildren;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            parentCategory.name,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 6.h),
          Text(
            LocaleKeys.productsCount.tr(
              args: ['${parentCategory.productCount}'],
            ),
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: childrenCategories.isEmpty
                ? Center(
                    child: Text(
                      vm._searchQuery.trim().isNotEmpty
                          ? LocaleKeys.categoriesNoMatchingSub.tr()
                          : LocaleKeys.categoriesNoSub.tr(),
                    ),
                  )
                : GridView.builder(
                    itemCount: childrenCategories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.82,
                    ),
                    itemBuilder: (context, index) {
                      return CategoryGridItem(
                        category: childrenCategories[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
