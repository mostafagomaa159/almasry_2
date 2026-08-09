part of '../product_details_imports.dart';

class ProductDetailsImageSection extends StatefulWidget {
  final String imagePath;
  final ProductModel product;
  final VoidCallback onFavoriteTap;

  const ProductDetailsImageSection({
    super.key,
    required this.imagePath,
    required this.product,
    required this.onFavoriteTap,
  });

  @override
  State<ProductDetailsImageSection> createState() =>
      _ProductDetailsImageSectionState();
}

class _ProductDetailsImageSectionState
    extends State<ProductDetailsImageSection> {
  late int _selectedIndex;
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _images = _collectImages();
  }

  List<String> _collectImages() {
    final images = <String>[];

    if (widget.imagePath.trim().isNotEmpty) {
      images.add(widget.imagePath);
    }

    return images.toSet().toList();
  }

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final currentImage = _images.isNotEmpty ? _images[_selectedIndex] : '';

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
      child: Column(
        children: [
          SizedBox(
            height: 320.h,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: currentImage.isEmpty
                        ? _buildPlaceholder()
                        : _buildMainImage(currentImage),
                  ),
                ),

                PositionedDirectional(
                  end: 0,
                  top: 48.h,
                  child: Column(
                    children: [
                      _ActionButton(icon: Icons.share_outlined, onTap: () {}),
                      SizedBox(height: 12.h),
                      _ActionButton(icon: Icons.chat_outlined, onTap: () {}),
                      SizedBox(height: 12.h),
                      BlocBuilder<
                        GenericCubit<FavoritesModel>,
                        GenericState<FavoritesModel>
                      >(
                        builder: (context, state) {
                          final data = state.data;
                          final isFavorite = data.isFavorite(
                            widget.product.sku,
                          );

                          return _ActionButton(
                            icon: isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            iconColor: isFavorite
                                ? Colors.red
                                : const Color(0xFF202020),
                            onTap: widget.onFavoriteTap,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                PositionedDirectional(
                  start: 0,
                  top: 110.h,
                  child: _ActionButton(
                    icon: Icons.balance_outlined,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),

          if (_images.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: List.generate(_images.length, (index) {
                  final image = _images[index];
                  final isSelected = index == _selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 74.w,
                      height: 74.h,
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF11385B)
                              : const Color(0xFFE0E0E0),
                          width: isSelected ? 1.4 : 1,
                        ),
                      ),
                      child: _buildImage(image, fit: BoxFit.contain),
                    ),
                  );
                }),
              ),
            ),
          ],

          SizedBox(height: 18.h),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE9E9E9)),
        ],
      ),
    );
  }

  Widget _buildMainImage(String imagePath) {
    return SizedBox(
      width: double.infinity,
      child: _buildImage(imagePath, fit: BoxFit.contain, height: 250.h),
    );
  }

  Widget _buildImage(String path, {BoxFit fit = BoxFit.cover, double? height}) {
    if (_isNetworkImage(path)) {
      return Image.network(
        path,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }

    return Image.asset(
      path,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 180.w,
      height: 180.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 34.sp,
        color: const Color(0xFF9E9E9E),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 22.sp,
          color: iconColor ?? const Color(0xFF202020),
        ),
      ),
    );
  }
}
