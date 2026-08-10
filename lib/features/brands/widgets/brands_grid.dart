part of '../brands_imports.dart';

class BrandsGrid extends StatelessWidget {
  final BrandsViewModel vm;
  final List<BrandModel> brands;
  final bool isLoadingMore;

  const BrandsGrid({
    super.key,
    required this.vm,
    required this.brands,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: vm._scrollController,
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      itemCount: brands.length + (isLoadingMore ? 1 : 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (index >= brands.length) {
          return Center(
            child: SizedBox(
              width: 22.w,
              height: 22.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primaryRed,
              ),
            ),
          );
        }

        final BrandModel brand = brands[index];

        return BrandGridItem(brand: brand, onTap: () => vm._openBrand(brand));
      },
    );
  }
}
