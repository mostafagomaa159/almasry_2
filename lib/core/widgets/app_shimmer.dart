import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Wraps a skeleton layout in the app's shimmer sweep. Give it grey blocks
/// shaped like the content that is coming — it paints the animation, the
/// caller owns the shape.
class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEDEDED),
      highlightColor: const Color(0xFFF8F8F8),
      child: child,
    );
  }
}
