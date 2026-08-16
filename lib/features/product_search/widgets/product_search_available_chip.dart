part of '../product_search_imports.dart';

/// The "Available only" stock filter. Off it is a plain outlined pill; on it
/// turns red and grows the circular clear badge that switches it back off.
class ProductSearchAvailableChip extends StatelessWidget {
  final ProductSearchViewModel vm;
  final bool isSelected;

  const ProductSearchAvailableChip({
    super.key,
    required this.vm,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(24.r);

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Material(
        color: isSelected ? AppColors.primaryRed : AppColors.white,
        borderRadius: radius,
        child: InkWell(
          onTap: vm._toggleAvailableOnly,
          borderRadius: radius,
          child: Container(
            padding: EdgeInsetsDirectional.fromSTEB(
              isSelected ? 8.w : 18.w,
              10.h,
              18.w,
              10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: isSelected ? AppColors.primaryRed : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white.withValues(alpha: 0.25),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.close,
                      size: 15.sp,
                      color: AppColors.white,
                    ),
                  ),
                  8.horizontalSpace,
                ],
                Text(
                  LocaleKeys.productSearchAvailableOnly.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
