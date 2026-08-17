import 'package:almasry_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// `Image.network` with the placeholder every call site was rolling by hand.
/// An empty [url] short-circuits to [placeholder] instead of failing a
/// request first.
class CustomAppNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  /// Drawn when [url] is empty or the request fails.
  final Widget? placeholder;

  /// Shows a spinner while the bytes arrive.
  final bool showLoader;

  const CustomAppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) return _placeholder();

    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
      loadingBuilder: !showLoader
          ? null
          : (context, child, progress) {
              if (progress == null) return child;

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
            },
    );
  }

  Widget _placeholder() {
    return placeholder ??
        Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 32.sp,
            color: Colors.grey.shade400,
          ),
        );
  }
}
