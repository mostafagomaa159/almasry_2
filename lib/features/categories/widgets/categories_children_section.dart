part of '../categories_imports.dart';

class CategoriesChildrenSection extends StatelessWidget {
  final CategoryModel? parentCategory;

  const CategoriesChildrenSection({
    super.key,
    required this.parentCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (parentCategory == null) {
      return const Center(
        child: Text('No category selected'),
      );
    }

    final children = parentCategory!.childrenData;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            parentCategory!.name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '${parentCategory!.productCount} products',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: children.isEmpty
                ? const Center(
              child: Text('No subcategories found'),
            )
                : GridView.builder(
              itemCount: children.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) {
                return CategoryGridItem(category: children[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
