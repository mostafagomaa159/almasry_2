part of '../categories_imports.dart';

class CategoryGridItem extends StatelessWidget {
  final CategoryModel category;

  const CategoryGridItem({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE9E9E9)),
      ),
      child: Column(
        children: [
          Expanded(
            child: category.image.trim().isEmpty
                ? const Icon(Icons.image_outlined)
                : Image.network(
              category.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Icon(Icons.image_outlined);
              },
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${category.productCount} products',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
