part of '../brands_imports.dart';

class BrandGridItem extends StatelessWidget {
  final BrandModel brand;
  final VoidCallback onTap;

  const BrandGridItem({super.key, required this.brand, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFEAEAEA)),
          ),
          child: Center(
            child: brand.hasImage
                ? AppNetworkImage(
                    url: brand.image,
                    fit: BoxFit.contain,
                    placeholder: _BrandNameLabel(name: brand.name),
                  )
                : _BrandNameLabel(name: brand.name),
          ),
        ),
      ),
    );
  }
}

class _BrandNameLabel extends StatelessWidget {
  final String name;

  const _BrandNameLabel({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
