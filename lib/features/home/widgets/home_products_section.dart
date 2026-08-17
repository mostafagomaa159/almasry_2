part of '../home_imports.dart';

class HomeProductsSection extends StatefulWidget {
  final HomeViewModel vm;
  final List<ProductModel> products;

  const HomeProductsSection({
    super.key,
    required this.vm,
    required this.products,
  });

  @override
  State<HomeProductsSection> createState() => _HomeProductsSectionState();
}

class _HomeProductsSectionState extends State<HomeProductsSection> {
  final ScrollController _scrollController = ScrollController();
  int visibleCount = 5;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant HomeProductsSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.products != widget.products) {
      visibleCount = 5;
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (isLoadingMore) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 150) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (visibleCount >= widget.products.length) return;

    setState(() {
      isLoadingMore = true;
    });

    Future.delayed(AppDurations.listStagger, () {
      if (!mounted) return;

      setState(() {
        visibleCount = (visibleCount + 5).clamp(0, widget.products.length);
        isLoadingMore = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleProducts = widget.products.take(visibleCount).toList();

    return SizedBox(
      height: 330.h,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: visibleProducts.length,
        itemBuilder: (context, index) {
          final product = visibleProducts[index];
          final hasNetworkImage = product.imageUrl.isNotEmpty;
          final imagePath = hasNetworkImage
              ? product.imageUrl
              : AppImages.redBigCard;

          return ProductCard(
            vm: widget.vm,
            sku: product.sku,
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
