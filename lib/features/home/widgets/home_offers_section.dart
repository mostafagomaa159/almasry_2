part of '../home_imports.dart';

class HomeOffersSection extends StatelessWidget {
  final bool isArabic;
  final List<HomeSubCategoryResponse> items;

  const HomeOffersSection({
    super.key,
    required this.isArabic,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 150.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: isArabic,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 18.w),
        itemBuilder: (context, index) {
          final item = items[index];

          return _HomeOfferItem(
            title: item.name,
            imagePath: item.image,
            isNetworkImage: true,
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

  const _HomeOfferItem({
    required this.title,
    required this.imagePath,
    required this.isNetworkImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 86.w,
            height: 86.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFCEEE8),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 66.w,
              height: 66.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
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
