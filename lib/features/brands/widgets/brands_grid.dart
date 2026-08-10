part of '../brands_imports.dart';

class BrandsGrid extends StatelessWidget {
  final BrandsViewModel vm;
  final BrandsData data;

  const BrandsGrid({super.key, required this.vm, required this.data});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: vm._scrollController,
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      itemCount: data.brands.length + (data.isLoadingMore ? 1 : 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (index >= data.brands.length) {
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

        final BrandModel brand = data.brands[index];

        return BrandGridItem(brand: brand, onTap: () => vm._openBrand(brand));
      },
    );
  }
}
