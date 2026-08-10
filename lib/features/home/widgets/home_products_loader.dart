part of '../home_imports.dart';

/// Placeholder shown while phase two is in flight. Matches the 330.h of
/// [HomeProductsSection] so the page doesn't jump when the products land.
class HomeProductsLoader extends StatelessWidget {
  const HomeProductsLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330.h,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primaryRed),
      ),
    );
  }
}
