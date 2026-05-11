import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsImageSection extends StatelessWidget {
  final String imagePath;

  const ProductDetailsImageSection({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        imagePath,
        height: 190.h,
        fit: BoxFit.contain,
      ),
    );
  }
}
