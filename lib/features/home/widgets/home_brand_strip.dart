part of '../home_imports.dart';

class BrandStrip extends StatelessWidget {
  final List<HomeBrandModel> brands;

  const BrandStrip({super.key, required this.brands});

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 180.h,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemCount: brands.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 1.25,
        ),
        itemBuilder: (context, index) {
          final brand = brands[index];

          return _BrandItem(brand: brand);
        },
      ),
    );
  }
}

class _BrandItem extends StatelessWidget {
  final HomeBrandModel brand;

  const _BrandItem({required this.brand});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Center(
        child: Image.network(
          brand.image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.broken_image_outlined,
              color: Colors.grey.shade400,
              size: 22.sp,
            );
          },
        ),
      ),
    );
  }
}
