part of '../home_imports.dart';

class HomeProductsSection extends StatelessWidget {
  final bool isArabic;
  final List<ProductResponse> products;

  const HomeProductsSection({
    super.key,
    required this.isArabic,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 330.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: isArabic,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final hasNetworkImage = product.imageUrl.isNotEmpty;
          final imagePath = hasNetworkImage
              ? product.imageUrl
              : AppImages.redBigCard;

          return ProductCard(
            productId: product.id.toString(),
            imagePath: imagePath,
            isNetworkImage: hasNetworkImage,
            title: product.name.isNotEmpty ? product.name : '-',
            price: product.price.toString(),
            oldPrice: '',
            category: '',
            description: '',
            discountText: '',
            pointsText: '',
            rating: 0,
          );
        },

      ),
    );
  }
}
