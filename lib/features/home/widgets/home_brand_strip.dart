part of '../home_imports.dart';

class BrandStrip extends StatelessWidget {
  final List<HomeBrandResponse> brands;

  const BrandStrip({
    super.key,
    required this.brands,
  });

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      height: 74.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final brand = brands[index];

          return SizedBox(
            width: 100.w,
            child: Image.network(
              brand.image,
              fit: BoxFit.contain,
              height: 28.h,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
