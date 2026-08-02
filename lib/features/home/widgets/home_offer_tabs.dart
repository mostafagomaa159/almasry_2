part of '../home_imports.dart';

class HomeOfferTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const HomeOfferTabs({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = [
      LocaleKeys.homeBeautyOffers.tr(),
      LocaleKeys.homePersonalCareOffers.tr(),
      LocaleKeys.homeCareOffers.tr(),
    ];

    return SizedBox(
      height: 46.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemCount: tabs.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              constraints: BoxConstraints(minWidth: 95.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryRed : AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFE8E8E8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeOfferItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isNetworkImage;
  final VoidCallback onTap;

  const _HomeOfferItem({
    required this.title,
    required this.imagePath,
    required this.isNetworkImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88.w,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 86.w,
              height: 86.h,
              decoration: const BoxDecoration(
                color: Color(0xFFFCEEE8),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Container(
                width: 66.w,
                height: 66.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: _buildImage(),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF18314F),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath.trim().isEmpty) {
      return _buildPlaceholder();
    }

    if (isNetworkImage) {
      return Image.network(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }

    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF8DCD2),
      alignment: Alignment.center,
      child: Icon(
        Icons.local_offer_outlined,
        color: const Color(0xFFB98B7B),
        size: 24.sp,
      ),
    );
  }
}
