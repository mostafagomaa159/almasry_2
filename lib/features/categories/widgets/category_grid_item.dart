part of '../categories_imports.dart';

class CategoryGridItem extends StatelessWidget {
  final CategoryModel category;

  const CategoryGridItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Expanded(
            child: category.image.trim().isEmpty
                ? const Icon(Icons.image_outlined)
                : CustomAppNetworkImage(
                    url: category.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: const Icon(Icons.image_outlined),
                  ),
          ),
          10.verticalSpace,
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
          ),
          4.verticalSpace,
          Text(
            '${category.productCount} products',
            style: TextStyle(fontSize: 11.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
