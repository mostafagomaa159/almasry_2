part of '../brands_imports.dart';

class BrandsLoadingView extends StatelessWidget {
  const BrandsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryRed),
    );
  }
}
